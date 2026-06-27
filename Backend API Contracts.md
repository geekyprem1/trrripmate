# TripMate — Backend API Contracts

**Version:** 1.0
**Status:** Ready for Engineering
**Last Updated:** 2026-06-26
**Author:** Principal Backend Engineer
**Companion Docs:** Product Vision v1.0, PRD v2.0, Technical Architecture v1.0, Database Design v1.0
**Scope:** API surface contracts only. No implementation code.

---

## 1. API Architecture & Conventions

### 1.1 Supabase-First Surface
TripMate exposes **three** backend interfaces. Pick the lowest-privilege one that fits:

| Surface | Use for | Auth | Authorization |
|---------|---------|------|---------------|
| **PostgREST (auto REST)** | Plain CRUD on tables (reads, simple writes) | User JWT | RLS only |
| **RPC (Postgres functions)** | Multi-row transactions, invariants, computed ops (settlement calc, split write) | User JWT | RLS + `security definer` checks |
| **Edge Functions** | Privileged/secret logic (invite accept, notifications, AI proxy, cleanup) | User JWT *or* service role | Explicit in-function checks |

**Rule:** the client never calls anything with a service-role key. Service role lives only inside Edge Functions.

### 1.2 Base URLs
- PostgREST: `{SUPABASE_URL}/rest/v1/{table}`
- RPC: `{SUPABASE_URL}/rest/v1/rpc/{function_name}`
- Edge Functions: `{SUPABASE_URL}/functions/v1/{function_name}`
- Storage: `{SUPABASE_URL}/storage/v1/object/...`
- Realtime: `wss://{SUPABASE_HOST}/realtime/v1`

### 1.3 Common Headers
| Header | Required | Notes |
|--------|----------|-------|
| `Authorization: Bearer <jwt>` | Yes (except auth/public) | Supabase access token |
| `apikey: <anon_key>` | Yes | Public anon key |
| `Content-Type: application/json` | On writes | — |
| `Idempotency-Key: <uuid>` | On all creates | Dedupe offline-queued retries (§12) |
| `Prefer: return=representation` | Optional | Return the written row |
| `X-Client-Version` | Recommended | For server-side compat gating |

### 1.4 Conventions
- **IDs:** client-generated `uuid` (offline-first); server accepts client `id` on insert.
- **Timestamps:** ISO-8601 UTC (`timestamptz`).
- **Money:** decimal string or number with 2 dp (maps to `numeric(14,2)`); never float-rounded client-side.
- **Soft delete:** writes set `deleted_at`; reads default-filter `deleted_at is null`.
- **Naming:** snake_case fields (matches DB), to keep PostgREST 1:1.

### 1.5 Standard Envelopes
RPC/Edge Function success:
```json
{ "data": { /* payload */ }, "meta": { "request_id": "uuid" } }
```
Error (all surfaces, normalized by client):
```json
{
  "error": {
    "code": "EXPENSE_AMOUNT_INVALID",
    "message": "Amount must be greater than 0.",
    "http_status": 422,
    "details": { "field": "amount" },
    "request_id": "uuid"
  }
}
```
> PostgREST returns native error bodies; the client maps `code`/`PGRST*`/`23xxx` to the normalized envelope above.

---

## 2. Authentication

Auth is handled by **Supabase Auth** (GoTrue). Contracts below are the surfaces the client uses; tokens flow into every other call.

### 2.1 Endpoints
| Action | Method · Path | Body | Returns |
|--------|---------------|------|---------|
| Email sign-up | `POST /auth/v1/signup` | `{ email, password }` | `{ user, session }` |
| Email sign-in | `POST /auth/v1/token?grant_type=password` | `{ email, password }` | `{ access_token, refresh_token, user }` |
| Phone OTP request | `POST /auth/v1/otp` | `{ phone }` | `{ message_id }` |
| Phone OTP verify | `POST /auth/v1/verify` | `{ phone, token, type:"sms" }` | `{ access_token, refresh_token, user }` |
| OAuth (Google/Apple) | `GET /auth/v1/authorize?provider=...` | — | Redirect → session |
| Refresh | `POST /auth/v1/token?grant_type=refresh_token` | `{ refresh_token }` | new tokens |
| Sign out | `POST /auth/v1/logout` | — | `204` |

### 2.2 Post-Auth Client Obligations
1. Upsert `profiles` row (`PATCH /rest/v1/profiles?id=eq.<uid>`).
2. Register device: **RPC `register_device`** (§4.9).
3. Subscribe Realtime to active trips.

### 2.3 Validation
| Field | Rule |
|-------|------|
| email | RFC 5322; unique per identity |
| password | ≥ 8 chars |
| phone | E.164 |
| OTP | 6 digits, 5-min TTL, ≤ 5 attempts, resend throttled (§13) |

### 2.4 Auth Error Codes
| Code | HTTP | Meaning |
|------|------|---------|
| `AUTH_INVALID_CREDENTIALS` | 400 | Wrong email/password |
| `AUTH_OTP_INVALID` | 400 | Wrong/expired OTP |
| `AUTH_OTP_THROTTLED` | 429 | Too many OTP requests |
| `AUTH_EMAIL_TAKEN` | 409 | Email already registered |
| `AUTH_SESSION_EXPIRED` | 401 | Refresh required |
| `AUTH_UNAUTHORIZED` | 401 | Missing/invalid token |

---

## 3. CRUD via PostgREST (RLS-Governed)

Direct table access for simple reads/writes. **All rows filtered by RLS** (`is_trip_member`); the contracts below state the *intended* access — RLS enforces it.

### 3.1 Profiles
| Op | Request | Permission |
|----|---------|------------|
| Read | `GET /profiles?id=eq.<uid>` | Any authed (display) |
| Update own | `PATCH /profiles?id=eq.<uid>` `{ display_name?, avatar_url? }` | Self only |

### 3.2 Trips
| Op | Request | Permission |
|----|---------|------------|
| List mine | `GET /trips?select=*,trip_members!inner(role)&order=updated_at.desc` | Member |
| Read one | `GET /trips?id=eq.<id>` | Member |
| Create | `POST /trips` (use **RPC `create_trip`**, §4.1, for quota enforcement) | Self → owner |
| Update | `PATCH /trips?id=eq.<id>` `{ name?, destination?, dates?, total_budget?, currency? }` | Owner |
| Archive | `PATCH /trips?id=eq.<id>` `{ status:"archived" }` | Owner |
| Soft delete | use **RPC `delete_trip`** (§4.2) | Owner |

**Trip object (read model):**
```json
{
  "id":"uuid","owner_id":"uuid","name":"Goa 2026","destination":"Goa",
  "start_date":"2026-07-01","end_date":"2026-07-05","currency":"INR",
  "total_budget":"50000.00","status":"active",
  "created_at":"...","updated_at":"...","version":3
}
```

### 3.3 Expenses
| Op | Request | Permission |
|----|---------|------------|
| List | `GET /expenses?trip_id=eq.<id>&deleted_at=is.null&order=expense_date.desc&limit=50` | Member |
| Read | `GET /expenses?id=eq.<id>` | Member |
| Create | **RPC `create_expense`** (§4.3) — writes expense + splits atomically | Member |
| Update | **RPC `update_expense`** (§4.4) | Owner / author |
| Delete | **RPC `delete_expense`** (§4.5) | Owner |
| Approve/Reject | **RPC `set_expense_status`** (§4.6) | Owner |

### 3.4 Members / Settlements / Notifications (reads)
| Op | Request | Permission |
|----|---------|------------|
| List members | `GET /trip_members?trip_id=eq.<id>&status=eq.active` | Member |
| List settlements | `GET /settlements?trip_id=eq.<id>&order=status` | Member |
| List notifications | `GET /notifications?user_id=eq.<uid>&order=created_at.desc&limit=30` | Self |
| Mark notif read | `PATCH /notifications?id=eq.<id>` `{ is_read:true }` | Self |

### 3.5 Filtering / Sorting (PostgREST operators)
- Equality `?col=eq.x`, in `?col=in.(a,b)`, range `?col=gte.x&col=lte.y`, null `?col=is.null`.
- Sort `?order=col.desc.nullslast`. Embed `?select=*,children(*)`.

---

## 4. RPC Endpoints (Postgres Functions)

RPCs wrap **transactional/invariant-bearing** operations. All are `POST /rest/v1/rpc/<name>`, run under the caller's JWT, and enforce permission + validation server-side. All return the standard envelope.

### 4.1 `create_trip`
- **Purpose:** Create trip + owner membership; enforce free-tier limit.
- **Request:** `{ id, name, destination?, start_date?, end_date?, currency, total_budget?, idempotency_key }`
- **Response:** `{ data: Trip }`
- **Validation:** name 1–60; `end_date≥start_date`; `total_budget≥0`; currency 3-char.
- **Business:** caller becomes `owner`; reject if caller already has 3 active trips on `free` tier → `QUOTA_TRIP_LIMIT`.
- **Permission:** any authed user.

### 4.2 `delete_trip`
- **Request:** `{ trip_id }` → **Response:** `{ data: { id, status:"deleted" } }`
- **Business:** soft-delete trip + cascade soft-delete members/expenses/splits/settlements in one transaction; warn flag if unsettled balances.
- **Permission:** owner only → else `PERMISSION_DENIED`.

### 4.3 `create_expense`
- **Purpose:** Atomically insert expense + its splits; recompute nothing server-side (budget derived client-side).
- **Request:**
```json
{
  "id":"uuid","trip_id":"uuid","paid_by":"member_uuid",
  "amount":"1200.00","currency":"INR","category":"fuel",
  "description":"Petrol","expense_date":"2026-07-01T10:00:00Z",
  "split_type":"equal","splits":[
    {"id":"uuid","member_id":"m1","share_amount":"600.00"},
    {"id":"uuid","member_id":"m2","share_amount":"600.00"}
  ],
  "idempotency_key":"uuid"
}
```
- **Response:** `{ data: Expense + splits }`
- **Validation:** `amount>0`; `category` in enum; `paid_by` active member; ≥1 split; **Σ share_amount = amount** (remainder to payer) → else `EXPENSE_SPLIT_MISMATCH`.
- **Business:** status = `pending` if trip requires approval, else `approved`.
- **Permission:** active member.

### 4.4 `update_expense`
- **Request:** `{ id, amount?, category?, description?, expense_date?, splits?, expected_version }`
- **Response:** `{ data: Expense }`
- **Validation:** same as create; **optimistic concurrency** — `expected_version` must equal current `version` else `CONFLICT_VERSION` (409).
- **Business:** material change (amount/splits) on approved expense → reverts status to `pending`.
- **Permission:** author (own) or owner.

### 4.5 `delete_expense`
- **Request:** `{ id }` → **Response:** `{ data:{ id, deleted_at } }`
- **Business:** soft-delete expense + cascade soft-delete splits + receipt; excluded from settlement. Block if expense is in a `completed` settlement → `EXPENSE_SETTLED_LOCKED`.
- **Permission:** owner.

### 4.6 `set_expense_status`
- **Request:** `{ id, status:"approved"|"rejected", note? }`
- **Response:** `{ data: Expense }`
- **Validation:** current status must be `pending` else `EXPENSE_STATUS_INVALID`.
- **Business:** emits `expense_approved`/`expense_rejected` notification (via trigger → Edge fn).
- **Permission:** owner.

### 4.7 `compute_settlement`
- **Purpose:** Recompute minimal "who pays who" from approved expenses; upsert `settlements` (preserving `completed` rows).
- **Request:** `{ trip_id }`
- **Response:** `{ data: { settlements:[ { id, from_member_id, to_member_id, amount, status } ], net_balances:[ {member_id, net} ] } }`
- **Validation:** Σ net_balances = 0 (invariant).
- **Business:** minimize transaction count; new expenses since last `completed` reopen pending rows; does not delete completed history.
- **Permission:** member (read/compute).

### 4.8 `mark_settlement_paid`
- **Request:** `{ id, expected_version }` → **Response:** `{ data: Settlement }`
- **Validation:** status `pending`→`completed`; idempotent (already completed → no-op success).
- **Permission:** owner or the `from_member`'s user → else `PERMISSION_DENIED`.

### 4.9 `register_device`
- **Request:** `{ fcm_token, platform }` → **Response:** `{ data:{ device_id } }`
- **Business:** upsert by `fcm_token` (unique); refresh `last_seen_at`.
- **Permission:** self.

### 4.10 `remove_member`
- **Request:** `{ trip_id, member_id }` → **Response:** `{ data:{ member_id, status:"removed" } }`
- **Validation:** block if member has pending dues → `MEMBER_HAS_DUES`; cannot remove owner.
- **Business:** set `status=removed`, `removed_at`; past expenses retained/attributed.
- **Permission:** owner.

---

## 5. Edge Functions (Privileged)

Run with elevated rights and/or secrets. `POST /functions/v1/<name>`.

### 5.1 `invite-create`
- **Purpose:** Generate invitation + shareable code; optionally deliver to email/phone.
- **Request:** `{ trip_id, target_email?, target_phone? }`
- **Response:** `{ data:{ invitation_id, invite_code, deep_link, expires_at } }`
- **Validation:** owner only; one pending invite per invitee → reuse existing; valid email/phone if direct.
- **Side-effects:** sets `expires_at = now()+7d`; sends `invite_received` notification if direct.
- **Errors:** `PERMISSION_DENIED`, `INVITE_DUPLICATE`, `TRIP_ARCHIVED`.

### 5.2 `invite-accept`
- **Purpose:** Validate code + create membership (service role; bypasses member-insert RLS under checks).
- **Request:** `{ invite_code }`
- **Response:** `{ data:{ trip_id, member_id, role:"member" } }`
- **Validation:** invite `pending` & not expired → else `INVITE_EXPIRED`/`INVITE_INVALID`; not already a member.
- **Side-effects:** invitation→`accepted` (`accepted_by`); insert `trip_members`; notify owner `invite_accepted`.

### 5.3 `invite-reject`
- **Request:** `{ invite_code }` → **Response:** `{ data:{ status:"rejected" } }`
- **Validation:** invite `pending`. Terminal afterward.

### 5.4 `notify-dispatch` *(internal, service-role only)*
- **Purpose:** Fan-out push via FCM from DB triggers/queued events. **Not client-callable.**
- **Request (internal):** `{ user_ids[], type, title, body, payload }`
- **Behavior:** writes `notifications` rows + sends FCM to each user's active `devices`; prunes dead tokens.

### 5.5 `report-export` *(optional server render)*
- **Purpose:** Server-side PDF for very large trips (client renders by default).
- **Request:** `{ trip_id, filters?:{ from?, to?, member_id?, category? } }`
- **Response:** `{ data:{ signed_url, expires_at } }`
- **Permission:** member. Rate-limited (§13).

### 5.6 `account-delete` *(GDPR)*
- **Request:** `{ confirm:true }` → **Response:** `202 { data:{ status:"scheduled" } }`
- **Behavior:** hard-delete/anonymize per retention policy; revokes sessions/devices.

### 5.7 `storage-sign` (see §9)

---

## 6. AI Endpoints (v1.5)

All via Edge Function proxy — **OpenRouter key never on device**. Categorization sync; insights async.

### 6.1 `ai-categorize`
- **Request:** `{ trip_id, description, amount }`
- **Response:**
```json
{ "data": { "category":"drinks", "confidence":0.82, "source":"ai|cache" } }
```
- **Behavior:** output constrained to category enum; PII-minimized payload; cache by normalized `description` (30-day TTL).
- **Thresholds (client-applied):** auto-apply ≥0.75, suggest ≥0.4, else none.
- **Fallback:** timeout (≥3s) / error → `{ data:{ category:null, source:"fallback" } }` (never blocks save).
- **Errors:** `AI_TIMEOUT` (returns fallback, not hard error), `AI_RATE_LIMITED` (429).
- **Permission:** member. Rate-limited per user (§13).

### 6.2 `ai-insights`
- **Request:** `{ trip_id }`
- **Response (async):** `202 { data:{ job_id } }` → result written to `trip_insights`, delivered via Realtime/sync.
- **Behavior:** generates spend summary, budget analysis, suggestions; cached until next material expense change.
- **Latency:** target <5s async; categorization <1.5s p95.
- **Permission:** owner (trigger), member (read result).

---

## 7. Realtime Events

Postgres CDC over WebSocket; **filtered per `trip_id`**; RLS still applies (members only receive permitted rows).

### 7.1 Subscription Contract
- Channel: `trip:{trip_id}` bound to tables `trips, trip_members, expenses, expense_splits, settlements` (+ `notifications` on `user:{uid}`).
- Filter example: `expenses:trip_id=eq.<id>`.
- Lifecycle: subscribe on trip-open; unsubscribe on background; **catch-up pull** (`updated_at > cursor`) on (re)subscribe to fill gaps.

### 7.2 Event Payload (per change)
```json
{
  "schema":"public","table":"expenses","type":"INSERT|UPDATE|DELETE",
  "commit_timestamp":"...","record":{ /* new row */ },
  "old_record":{ "id":"uuid" }
}
```

### 7.3 Event Catalog (client semantics)
| Table · Type | Client reaction |
|--------------|-----------------|
| `expenses INSERT/UPDATE` | Upsert into Drift → budget/list refresh |
| `expenses DELETE` (soft) | Mark deleted locally |
| `expense_splits *` | Recompute balances |
| `settlements UPDATE` | Refresh settlement status |
| `trip_members INSERT/UPDATE` | Roster/role refresh |
| `trips UPDATE` | Metadata/budget/status (archive) refresh |
| `notifications INSERT` | Badge/feed update |

**Echo suppression:** ignore events whose `idempotency_key`/`id` matches a local pending write.

---

## 8. Storage Endpoints (Receipts)

Private bucket `receipts`; path `trip_id/expense_id/<uuid>.<ext>`. Storage RLS mirrors `is_trip_member`.

### 8.1 Upload
- `POST /storage/v1/object/receipts/{trip_id}/{expense_id}/{uuid}.jpg`
- Headers: `Authorization`, `Content-Type: image/jpeg|png|heic`.
- **Validation:** ≤10 MB; allowed MIME; path `trip_id` must match a trip the user belongs to.
- **Response:** `{ Key, path }` → client patches `receipts.storage_path`, `upload_status="uploaded"`.
- **Errors:** `STORAGE_TOO_LARGE` (413), `STORAGE_MIME_INVALID` (415), `STORAGE_UPLOAD_FAILED` (5xx → client retries with backoff).

### 8.2 Signed Read URL — Edge `storage-sign`
- **Request:** `{ expense_id }` (or `storage_path`)
- **Response:** `{ data:{ signed_url, expires_at } }` (short TTL, e.g. 60 min)
- **Permission:** member of the receipt's trip.

### 8.3 Delete
- Handled by retention/cleanup job (service role) on expense hard-delete; clients do not directly delete objects.

---

## 9. Pagination

**Default for all list reads.** Two supported modes:

### 9.1 Keyset (preferred for sync & infinite scroll)
- Query: `?order=updated_at.desc,id.desc&updated_at=lt.<cursor_ts>&limit=50`
- Response includes the last row's `(updated_at,id)` as the next cursor.
- Stable under inserts; used by **delta sync** (`updated_at > last_synced_at`).

### 9.2 Range (offset) — for finite report pages
- Header `Range: 0-49` (PostgREST) → `Content-Range: 0-49/237`.
- Use sparingly; avoid deep offsets.

**Limits:** default `limit=50`, max `limit=200`. Server caps over-large limits to 200.

---

## 10. Rate Limiting

Enforced at Edge Functions / gateway; PostgREST behind Supabase defaults.

| Surface | Limit (per user) | On exceed |
|---------|------------------|-----------|
| Auth OTP request | 5 / 15 min | `AUTH_OTP_THROTTLED` (429) |
| `invite-create` | 30 / hour | `RATE_LIMITED` (429) |
| `ai-categorize` | 60 / min | `AI_RATE_LIMITED` (429) |
| `ai-insights` | 10 / hour | `AI_RATE_LIMITED` (429) |
| `report-export` (server) | 10 / hour | `RATE_LIMITED` (429) |
| Generic writes (PostgREST/RPC) | 600 / min | `RATE_LIMITED` (429) |
| Storage upload | 120 / hour | `RATE_LIMITED` (429) |

**Headers on limited responses:** `Retry-After`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`. Clients honor `Retry-After` in the sync backoff.

---

## 11. Permissions Summary

Permission is enforced **server-side** (RLS + RPC/Edge checks); the table is the contract.

| Operation | Surface | Owner | Member | Notes |
|-----------|---------|:-----:|:------:|-------|
| Create trip | RPC | ✅ | ✅ | becomes owner; quota-checked |
| Edit/archive/delete trip | RPC/REST | ✅ | ❌ | owner only |
| Invite / remove member | Edge/RPC | ✅ | ❌ | — |
| Accept/reject invite | Edge | ✅ | ✅ | invitee |
| Add expense | RPC | ✅ | ✅ | — |
| Edit expense | RPC | ✅ | own only | author or owner |
| Delete expense | RPC | ✅ | ❌ | owner |
| Approve/reject expense | RPC | ✅ | ❌ | owner |
| Compute settlement | RPC | ✅ | ✅ | read |
| Mark settlement paid | RPC | ✅ | own txn | owner or debtor |
| Upload/read receipt | Storage | ✅ | ✅ | trip members |
| AI categorize/insights | Edge | ✅ | ✅(read) | insights trigger = owner |
| Manage own profile/devices/notifs | REST/RPC | ✅ | ✅ | self only |

---

## 12. Idempotency & Concurrency

- **Creates:** require `Idempotency-Key`/`idempotency_key`; server dedupes via unique constraint → replays return the original row (200, not duplicate).
- **Updates:** require `expected_version`; mismatch → `CONFLICT_VERSION` (409); client refetches, reapplies LWW, retries.
- **Deletes:** idempotent (already-deleted → success no-op).
- **Settlement mark-paid:** idempotent.
- This makes the **offline sync queue** safe to replay end-to-end.

---

## 13. Error Code Reference

| Code | HTTP | Surface | Meaning |
|------|------|---------|---------|
| `AUTH_UNAUTHORIZED` | 401 | all | Missing/invalid token |
| `AUTH_SESSION_EXPIRED` | 401 | all | Refresh needed |
| `PERMISSION_DENIED` | 403 | all | RLS/role check failed |
| `NOT_FOUND` | 404 | all | Row absent or not visible under RLS |
| `VALIDATION_FAILED` | 422 | all | Generic field validation |
| `EXPENSE_AMOUNT_INVALID` | 422 | RPC | amount ≤ 0 |
| `EXPENSE_SPLIT_MISMATCH` | 422 | RPC | Σ splits ≠ amount |
| `EXPENSE_STATUS_INVALID` | 409 | RPC | approve/reject non-pending |
| `EXPENSE_SETTLED_LOCKED` | 409 | RPC | delete settled expense |
| `MEMBER_HAS_DUES` | 409 | RPC | remove member with balance |
| `QUOTA_TRIP_LIMIT` | 402 | RPC | free-tier 3-trip cap |
| `INVITE_INVALID` | 400 | Edge | bad code |
| `INVITE_EXPIRED` | 410 | Edge | past `expires_at` |
| `INVITE_DUPLICATE` | 409 | Edge | pending invite exists |
| `TRIP_ARCHIVED` | 409 | all | write to archived trip |
| `CONFLICT_VERSION` | 409 | RPC | optimistic-lock mismatch |
| `STORAGE_TOO_LARGE` | 413 | Storage | > 10 MB |
| `STORAGE_MIME_INVALID` | 415 | Storage | bad type |
| `STORAGE_UPLOAD_FAILED` | 5xx | Storage | retryable |
| `AI_TIMEOUT` | 200* | Edge | returns fallback payload |
| `AI_RATE_LIMITED` | 429 | Edge | AI quota |
| `RATE_LIMITED` | 429 | all | generic throttle |
| `SERVER_ERROR` | 500 | all | unexpected; retryable |

\* `AI_TIMEOUT` surfaces as a successful fallback response, not a blocking error (PRD §13 / Architecture §11).

---

## 14. Versioning & Compatibility

- **Compatibility:** additive changes only within v1 (new optional fields, new endpoints). Breaking changes → new RPC/Edge name (e.g., `create_expense_v2`).
- **Client gating:** server reads `X-Client-Version`; may return `426 UPGRADE_REQUIRED` for unsupported old clients after a deprecation window.
- **Enums:** values are append-only (matches DB strategy); clients must tolerate unknown enum values (treat as `misc`/ignore).
- **Deprecation:** mark in this doc, keep ≥1 release, then remove (expand→contract, Architecture §18).

---

*This document defines TripMate's backend API contracts. It pairs with the Database Design (data) and Technical Architecture (system). Contract changes are versioned here and reviewed before rollout.*
