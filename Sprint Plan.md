# TripMate — Sprint Plan & Delivery Roadmap

**Version:** 1.0
**Status:** Ready for Execution
**Last Updated:** 2026-06-26
**Companion Docs:** PRD v2.0 · Technical Architecture v1.0 · Database Design v1.0 · Backend API Contracts v1.0 · UI/UX Spec v1.0 · Design System v1.0 · CLAUDE.md
**Cadence:** 2-week sprints (adjustable). 8 sprints → v1.0 release.

---

## 0. Sprint Overview

| Sprint | Theme | Ships | Release |
|--------|-------|-------|---------|
| **0** | Foundation *(pre-sprint / week 0)* | Scaffolding, theme, CI, Supabase project | — |
| **1** | Authentication | Sign-in (Google/Apple/Email/OTP), profile, session | — |
| **2** | Trips | Create/edit/archive/delete, trip list, dashboard shell, budget | — |
| **3** | Members | Invite/join/remove, roles, permissions, realtime roster | — |
| **4** | Expenses | Add/edit/delete, split, approval, receipts, offline sync | — |
| **5** | Settlement | Who-pays-who, mark paid, balances | — |
| **6** | Reports | Charts, filters, PDF export | — |
| **7** | Premium | Paywall, free-tier gating, subscriptions | — |
| **8** | Release | Hardening, store submission, observability | **v1.0** |

**Cross-cutting (every sprint):** offline-first, RLS, tests, accessibility, Design System tokens, CLAUDE.md compliance. **AI (v1.5) is OUT of v1.0** — do not build in sprints 1–8.

---

## Sprint 0 — Foundation (Pre-Sprint)

**Goal:** A runnable, CI-backed skeleton that all feature sprints plug into.

**Scope / Tasks**
- Flutter project + flavors (`dev`/`staging`/`prod`), `--dart-define` `AppConfig`.
- Folder structure per Architecture §3; `core/` scaffolding (error, network, sync, database, logging, analytics, widgets).
- Design System theme module: ColorSchemes (light/dark), type scale, tokens, shared `loading/empty/error` widgets.
- Drift database setup + migration harness; base sync engine skeleton (queue table, drain loop stub).
- Supabase projects (3 envs); base tables, **RLS enabled**, `is_trip_member` helper; migration CI.
- GoRouter shell + auth-redirect skeleton; Riverpod codegen wired.
- CI pipeline: analyze → format check → test → build flavors. `flutter_lints`/`very_good_analysis` configured (zero-warning gate).
- Crash reporting + logger sinks; analytics service contract (typed events).

**Definition of Done**
- App boots to a placeholder home in all flavors; CI green; theme + base states render; Drift opens; Supabase reachable with RLS on.

**Dependencies:** none. **Risk:** environment/CI setup — front-load it.

---

## Sprint 1 — Authentication

**Goal:** A user can sign in by any supported method and get a persistent session.

**Requirements:** REQ-AUTH-01, REQ-AUTH-02. **Screens:** Splash, Sign In, OTP Verify, Profile Setup.

**Scope / Tasks**
- `auth` feature (data/domain/presentation); Supabase Auth integration in remote source only.
- Google, Apple (iOS), Email/password, Phone OTP flows.
- `profiles` upsert post-auth; avatar optional (offline-deferred upload).
- Session persistence (`flutter_secure_storage`), auto-refresh, logout (with unsynced-data warning).
- `register_device` RPC (FCM token) post-login; de-register on logout.
- `authStateProvider` → GoRouter redirects + deep-link intent preservation.
- Error mapping: `AUTH_INVALID_CREDENTIALS`, `AUTH_OTP_INVALID`, `AUTH_OTP_THROTTLED`, `AUTH_EMAIL_TAKEN`, `AUTH_SESSION_EXPIRED`.

**Acceptance Criteria**
- All four methods sign in; session survives restart; logout clears session.
- OTP: 6-digit, 5-min TTL, resend throttle, ≤5 attempts.
- Profile setup required for new users; validation (name 1–60).
- Offline: cached session authorizes app; fresh sign-in shows "needs connection".

**Tests:** auth repo (fake sources), session resume, redirect logic, OTP validation, controller state matrix.
**Dependencies:** Sprint 0. **Demo:** sign in via each method → land on (empty) Trips.

---

## Sprint 2 — Trips

**Goal:** Owners create and manage trips; the dashboard + budget shell exists.

**Requirements:** REQ-TRIP-01..04, REQ-BUD-01. **Screens:** Trips (Home), Create/Edit Trip, Trip Dashboard, Archived Trips.

**Scope / Tasks**
- `trips` feature; `create_trip` / `delete_trip` RPCs; edit/archive via PostgREST under RLS.
- Trip list (cards, progress, status), pull-to-refresh, free-tier active-trip count.
- Create/Edit form (name, destination, dates, currency, budget) + validation.
- Trip Dashboard shell with NavigationBar (Dashboard/Expenses/Settlement/Reports tabs as placeholders), budget header (Total/Spent/Remaining/Daily — derived client-side), over-budget flag.
- Archive/unarchive + Archived screen (read-only enforcement).
- **Offline:** create/edit/archive queued with pending badges; full offline read.
- Realtime: `trips` channel → Drift ingest.

**Acceptance Criteria**
- Member cannot edit/delete/archive; owner can. 4th active trip (free) → paywall stub.
- Budget figures compute locally and update; lowering below spent flags over-budget.
- Soft-delete recoverable; archived trips read-only and excluded from active count.

**Tests:** trips repo, quota rule, budget derivation, soft-delete/restore, archived read-only, realtime ingest.
**Dependencies:** Sprint 1. **Demo:** create trip → dashboard with budget → archive → restore.

---

## Sprint 3 — Members

**Goal:** Owners invite people; invitees join; roles + permissions enforced.

**Requirements:** REQ-MEM-01..03. **Screens:** Members & Invite, Join Trip (Invite Accept).

**Scope / Tasks**
- `members` feature; `invite-create`, `invite-accept`, `invite-reject` Edge Functions; `remove_member` RPC.
- Invite sheet (share link/code, direct email/phone), 7-day expiry, one-pending-invite rule.
- Join flow via deep link → auth-if-needed → preview → accept/reject; expired handling.
- Roster with role chips + dues indicator; owner remove (dues-blocked).
- Permission matrix wired end-to-end (Owner/Member) at UI + relying on RLS.
- Realtime roster updates; notifications: `invite_received`, `invite_accepted`, `member_removed`.

**Acceptance Criteria**
- Owner-only invite/remove; member accept/reject; expired invite cannot be accepted.
- Remove blocked with dues (`MEMBER_HAS_DUES`); removed member's history retained.
- Deep link resumes after auth; double-accept/idempotent handling.

**Tests:** invite lifecycle, expiry, accept/reject, remove-with-dues block, permission enforcement, deep-link resume.
**Dependencies:** Sprint 2. **Demo:** invite via link → second account joins → appears in roster realtime.

---

## Sprint 4 — Expenses (largest sprint)

**Goal:** The core loop — add/edit/delete expenses, split, approve, receipts — fully offline-capable.

**Requirements:** REQ-EXP-01..06, REQ-BUD-01 (full). **Screens:** Expenses List, Add/Edit Expense, Expense Detail, Approval Queue.

**Scope / Tasks**
- `expenses` feature; `create_expense` / `update_expense` / `delete_expense` / `set_expense_status` RPCs (atomic expense+splits).
- Add/Edit form: amount, **manual category** (enum), payer, equal split + member checklist, date, notes.
- Split engine (equal; Σ=amount, remainder to payer); validation incl. duplicate-tap debounce + idempotency.
- Receipt capture/compress/upload (offline-cached, deferred), Storage bucket + signed-read; upload retry.
- Expense list (filters, grouping, status/sync badges), Expense Detail, Approval Queue (owner).
- Approve/reject → status + notifications (`expense_added`, `pending_approval`, `approved`, `rejected`, `budget_exceeded`).
- **Full offline sync hardening:** dependency-ordered queue, ID handling, conflict resolution (LWW/delete-wins/split-merge), backoff retry, pending/failed UI.
- Realtime: `expenses`/`expense_splits` → Drift → budget refresh.

**Acceptance Criteria**
- REQ-EXP-01 ACs met: amount>0, category/payer/split required, works offline, syncs later, loading shown, dashboard updates instantly.
- Edge cases handled: duplicate tap, invalid amount, deleted member, offline conflict, upload failure.
- Member edits own only; owner edits/deletes any; material edit reverts approved→pending; settled expense delete blocked.

**Tests:** split math + rounding, idempotent create, conflict resolution paths, receipt offline→upload, approval state machine, budget recompute, full state matrix.
**Dependencies:** Sprint 3. **Demo:** add expense offline → reconnect → syncs, approves, budget updates across devices.

---

## Sprint 5 — Settlement

**Goal:** Fair, clear "who pays who" with payment tracking.

**Requirements:** REQ-SET-01..02. **Screens:** Settlement.

**Scope / Tasks**
- `settlement` feature; `compute_settlement` (minimal transactions, nets to zero, preserves completed) + `mark_settlement_paid` RPCs.
- Net-balance summary (you owe / you're owed) with money colors+labels.
- Who-pays-who list; mark paid (owner or debtor), idempotent; settled state.
- Reopen on new approved expense after settlement.
- **Offline:** compute locally; mark-paid queued (pending badge).
- Notifications: `settlement_pending`, `settlement_completed`.

**Acceptance Criteria**
- Balances net to zero; minimal transaction count; matches manual calc.
- Mark paid updates both parties; idempotent; permission-gated.
- New expense reopens settlement; removed-member balances handled.

**Tests:** settlement algorithm (incl. single member, equal-paid, removed member), zero-sum invariant, mark-paid idempotency/permissions, reopen logic.
**Dependencies:** Sprint 4. **Demo:** mixed expenses → settlement graph → mark paid → "All settled".

---

## Sprint 6 — Reports

**Goal:** Visual breakdowns and exportable PDF.

**Requirements:** REQ-REP-01. **Screens:** Reports.

**Scope / Tasks**
- `reports` feature; client-side aggregation from approved expenses; optional `report-export` Edge Function for large trips.
- Charts (`fl_chart`): pie (category), bar (by member), timeline; Design System chart palette + **text/table equivalents** (a11y).
- Filters (date range, member, category); totals summary; empty states.
- PDF export (offline-capable, generated off-UI-isolate) + share sheet; Excel deferred to v2.0.

**Acceptance Criteria**
- Charts match totals; filters apply; empty-state when no data.
- PDF exports offline; large trips paginate; export retry on failure.
- Every chart has an accessible text/table equivalent.

**Tests:** aggregation correctness, filter logic, PDF generation (golden/structure), empty states, a11y equivalents present.
**Dependencies:** Sprint 5. **Demo:** filtered report → switch charts → export PDF offline.

---

## Sprint 7 — Premium

**Goal:** Monetization — paywall, free-tier enforcement, subscriptions.

**Requirements:** PRD §12 (monetization), `QUOTA_TRIP_LIMIT`. **Screens:** Paywall/Premium, Settings/Profile (subscription section).

**Scope / Tasks**
- Store billing integration (Play Billing / StoreKit) via a billing service; entitlement state in `profiles.tier`.
- Paywall screen (Free vs Premium comparison, plans, purchase, restore).
- Enforce free-tier gates: 3 active trips (`QUOTA_TRIP_LIMIT` → paywall), PDF/exports gating per PRD, Premium-only surfaces stubbed (AI entries gated/hidden until v1.5).
- Settings subscription management; restore purchases; entitlement sync.
- Analytics: `premium_viewed`, `subscription_purchased`.

**Acceptance Criteria**
- 4th active trip blocked on free → paywall; Premium unlocks unlimited.
- Purchase/restore reflect entitlement; offline purchase disabled gracefully.
- Entitlement persists and gates features correctly.

**Tests:** quota gating, entitlement state transitions, restore flow, gated-feature visibility, purchase error handling (mocked store).
**Dependencies:** Sprints 2 & 6. **Demo:** hit trip limit → paywall → (sandbox) purchase → unlimited.

---

## Sprint 8 — Release

**Goal:** Production-ready v1.0 on both stores.

**Scope / Tasks**
- **Hardening:** full regression on offline/sync, conflict edge cases, permissions, error states; crash-free tuning (>99.5%).
- **Performance pass:** <300ms screen budget verification, list virtualization, image sizes, cold-start, jank profiling.
- **Security review:** RLS audit, Storage policy audit, no secrets/PII in logs, token storage, run `/security-review`.
- **Accessibility audit:** TalkBack/VoiceOver pass, dynamic type 200%, contrast, chart equivalents.
- **Observability:** analytics events verified end-to-end (PRD §14), dashboards/alerts, crash reporting in prod.
- Store assets, listings, privacy policy, data-safety forms; staged rollout config; FCM prod keys.
- Notification fan-out (`notify-dispatch`) verified; retention jobs (`pg_cron`/Edge) scheduled.
- Backup/PITR + migration rollback rehearsal; release runbook.

**Acceptance Criteria**
- All v1.0 REQ-IDs pass; crash-free >99.5% in staging; security + a11y audits clear.
- Staged rollout live on Play + App Store; rollback path tested.
- Success-metric instrumentation emitting (downloads/active/trips/expenses/rating proxy).

**Dependencies:** Sprints 1–7. **Demo:** production build, full happy-path on real devices, dashboards live.

---

## 9. Cross-Sprint Tracks (continuous)

| Track | Rule |
|-------|------|
| **Offline-first** | Every write sprint extends the sync queue; conflict module stays centralized. |
| **Security/RLS** | Each new table/Edge fn ships with RLS + policy tests in the same sprint. |
| **Testing** | No story is "done" without tests (CLAUDE.md §7/§16). |
| **Accessibility** | Each screen meets a11y baseline in its own sprint, not deferred to Sprint 8. |
| **Design System** | Tokens only; new components added to inventory. |
| **Analytics** | Events for a feature ship with the feature. |
| **Docs** | Spec drift updated in the relevant doc per change. |

---

## 10. Dependency Graph

```
S0 Foundation
   └─ S1 Auth
        └─ S2 Trips
             ├─ S3 Members ──┐
             │               └─ S4 Expenses
             │                     └─ S5 Settlement
             │                          └─ S6 Reports
             ├─ S7 Premium (needs S2 quota + S6 export gating)
             └─ S8 Release (needs S1–S7)
```

---

## 11. Definition of Done (per sprint)

A sprint is complete only when:
1. All in-scope REQ-IDs implemented + acceptance criteria pass.
2. Offline + loading + error + empty states handled for every screen (UI/UX §3).
3. Tests cover logic, validation, sync/conflict, and state matrix (CLAUDE.md §7).
4. RLS/permissions enforced + tested; no secrets/PII leaks (CLAUDE.md §13).
5. Accessibility baseline met (Design System §17).
6. Zero analyzer warnings; CI green; demo-able happy path.
7. Design System tokens only; analytics events emitting.

---

## 12. Risks & Mitigations

| Risk | Sprint | Mitigation |
|------|--------|------------|
| Offline sync/conflict complexity | S4 | Centralize early (S0 skeleton); heavy test matrix; idempotency keys. |
| Apple sign-in / store review friction | S1, S8 | Implement Apple early; pre-read store guidelines; staged rollout. |
| Settlement algorithm correctness | S5 | Zero-sum invariant tests; reference manual calcs; property tests. |
| Receipt upload reliability | S4 | Deferred upload + backoff; expense usable without receipt. |
| Billing platform quirks | S7 | Sandbox testing both stores; entitlement as single source. |
| Realtime gaps/missed events | S2–S5 | Catch-up delta pulls on (re)subscribe; never rely on at-least-once. |
| Scope creep (AI into v1.0) | all | AI is v1.5 — gated/hidden; not built in S1–S8. |

---

*This plan sequences v1.0 delivery against the approved specs. Each sprint ships a demoable, tested, offline-safe slice. v1.5 (AI, push prefs, custom splits) begins after the v1.0 release.*
