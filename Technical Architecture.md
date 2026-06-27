# TripMate — Technical Architecture Document

**Version:** 1.0
**Status:** Ready for Engineering
**Last Updated:** 2026-06-26
**Author:** Principal Software Architect
**Companion Docs:** Product Vision v1.0, PRD v2.0 (Implementation-Ready)
**Scope:** System architecture only. No DB schema, no API contracts, no PRD feature restatement.

---

## 1. Architecture Overview

TripMate is an **offline-first, single-page mobile app** (Flutter) backed by **Supabase** (Postgres + Auth + Realtime + Storage). The client is the source of truth for the active session; the server is the source of truth for shared, durable state. The two reconcile through a **local-first write path with a sync queue**.

**Layered, feature-first architecture (per feature):**

```
UI (Widgets / Screens)
   ↓ ref.watch / ref.read
Controllers (Riverpod Notifiers — presentation state)
   ↓
Repositories (domain boundary — interface)
   ↓                ↘
Local Data (Drift)   Remote Data (Supabase client)
        ↘            ↙
      Sync Engine (queue + reconciler)
```

**Core principles enforced architecturally:**
- **Local-first writes:** every mutation hits Drift first, returns immediately, then syncs.
- **Single domain boundary:** UI never touches Supabase or Drift directly — only repositories.
- **Unidirectional data flow:** UI → controller → repository → data sources → streams back to UI.
- **Streams over fetches:** UI subscribes to Drift queries (reactive); remote changes flow into Drift, which re-emits to UI.

**Data flow (write):** UI → Controller → Repository → Drift (commit + enqueue SyncQueueItem) → UI updates from Drift stream → Sync Engine drains queue → Supabase → Realtime broadcast → other clients' Drift → their UI.

**Data flow (read):** UI watches Drift stream → always renders local cache → background sync refreshes Drift.

---

## 2. Technology Stack

| Concern | Choice | Notes |
|---------|--------|-------|
| UI framework | Flutter (stable) | Material 3 design system |
| Language | Dart 3+ | Sound null safety, records, sealed classes |
| State management | Riverpod (v2, code-gen) | `@riverpod` annotations; `AsyncNotifier` |
| Navigation | GoRouter | Declarative, deep-link/redirect support |
| Local DB | Drift (SQLite) | Reactive queries, migrations, type-safe |
| Backend | Supabase | Postgres, Auth, Realtime, Storage, Edge Functions |
| Realtime | Supabase Realtime | Postgres CDC over WebSocket |
| Push | Firebase Cloud Messaging | Server-triggered via Edge Functions |
| AI (v1.5) | OpenRouter | Gemini/Claude/GPT via Edge Function proxy |
| Serialization | `freezed` + `json_serializable` | Immutable models, unions |
| DI/Service locator | Riverpod providers | No GetIt; providers are the container |
| Functional errors | `Result`/sealed `Failure` | No exceptions across repository boundary |
| Logging | `logger` + custom sinks | Structured, level-gated |
| Charts | `fl_chart` | Reports (pie/bar/timeline) |
| PDF | `pdf` + `printing` | Local report export |
| Secure storage | `flutter_secure_storage` | Token/secret persistence |
| Env config | `--dart-define` + compile-time config | Per-flavor |

---

## 3. Folder Structure (Feature-First)

```
lib/
├── main.dart                      # Entry; flavor bootstrap
├── bootstrap.dart                 # DI init, Drift open, Supabase init, error zone
├── app/
│   ├── app.dart                   # MaterialApp.router
│   ├── router/                    # GoRouter config, routes, guards
│   └── theme/                     # Material 3 theme, tokens
├── core/
│   ├── config/                    # Env, flavors, constants
│   ├── error/                     # Failure, Result, error mapper
│   ├── network/                   # Connectivity, Supabase client provider
│   ├── sync/                      # Sync engine, queue, reconciler, conflict policy
│   ├── database/                  # Drift DB, DAOs base, migrations
│   ├── logging/                   # Logger, sinks
│   ├── analytics/                 # Analytics service, event contracts
│   └── widgets/                   # Shared UI primitives, states (loading/error/empty)
├── features/
│   ├── auth/
│   │   ├── data/                  # repo impl, local/remote sources, mappers
│   │   ├── domain/                # entities, repo interface, value objects
│   │   └── presentation/          # screens, widgets, controllers (providers)
│   ├── trips/
│   ├── members/
│   ├── expenses/
│   ├── budget/
│   ├── settlement/
│   ├── reports/
│   ├── notifications/
│   └── ai/                        # v1.5
└── shared/
    ├── models/                    # cross-feature models
    └── extensions/                # Dart extensions, formatters
```

**Rules:**
- A feature owns its `data/domain/presentation`. Cross-feature access goes through the other feature's **domain** (repo interface + entities), never its `data` or `presentation`.
- `core/` and `shared/` never depend on `features/`.
- Drift tables live in `core/database` but DAOs may be grouped per feature.

---

## 4. State Management (Riverpod)

**Provider taxonomy:**
- **Infrastructure providers** (singletons): `supabaseClientProvider`, `databaseProvider`, `connectivityProvider`, `syncEngineProvider`, `analyticsProvider`. Defined in `core/`.
- **Repository providers:** one per feature repo, depends on local + remote source providers.
- **Stream providers:** wrap Drift reactive queries (e.g., `tripListStreamProvider`) — UI's primary read path.
- **Controllers:** `AsyncNotifier`/`Notifier` per screen/use-case for mutations and transient UI state (form state, submit status).

**Conventions:**
- Use **code generation** (`riverpod_generator`) — `@riverpod` for all providers.
- UI **watches** stream providers for data; **reads** controllers via `ref.read(...).notifier` for actions.
- Mutations return `Result<T>`; controller maps to `AsyncValue` for loading/error UI.
- **No business logic in widgets.** Controllers orchestrate; repositories execute.
- Use `ref.invalidate`/`autoDispose` for scoped, short-lived state (e.g., a draft expense form).
- **Scoping:** trip-scoped providers take `tripId` as a family parameter.

**Example responsibilities:**
- `ExpenseListController` (family by tripId) → exposes Drift stream of expenses.
- `AddExpenseController` → validates, calls repo, tracks submit `AsyncValue`, handles debounce/idempotency.

---

## 5. Navigation (GoRouter)

**Structure:**
- Single `GoRouter` in `app/router`, route definitions co-located but referenced via typed route constants.
- **Shell route** for the authenticated bottom-nav (Trips, …); standalone routes for Auth, Invite-accept, Expense detail.

**Guards & redirects:**
- Global `redirect` based on `authStateProvider`: unauthenticated → `/auth`; authenticated hitting `/auth` → `/home`.
- **Deep links:** invite links (`/invite/:code`) and notification deep-links resolve through GoRouter; if unauthenticated, capture intended location and resume after login.
- **Permission-aware routes:** route-level redirect for Owner-only screens (e.g., approval queue) using current member role provider; unauthorized → fallback with toast.

**Patterns:**
- Use `refreshListenable`/`Listenable` bridged from Riverpod auth provider so router reacts to auth changes.
- Typed navigation helpers (no raw string paths in widgets).
- Preserve nav state per shell tab.

---

## 6. Offline Architecture (Drift + Sync Queue)

**Drift as the local source of truth:**
- All reads come from Drift (reactive queries → UI streams).
- All writes commit to Drift first with a **local UUID**, then enqueue a `SyncQueueItem`.
- Entities carry sync metadata: `localId`, `serverId?`, `dirty`, `deletedAt?`, `updatedAt`, `syncStatus`.

**Sync Engine (`core/sync`):**
- **Trigger:** on connectivity-regained, on app foreground, after each local mutation (debounced), and on a periodic timer.
- **Queue drain:** FIFO, **dependency-ordered** (Trip → Member/Expense → Split/Receipt). A child item is held until its parent has a `serverId`.
- **ID remapping:** on first successful create, server ID is written back and all local references rewritten in one transaction.
- **Idempotency:** each queue item carries an idempotency key; retried sends are server-deduplicated.

**Conflict resolution policy (centralized in one module):**
- Scalars → **last-write-wins** by `updatedAt`.
- Delete beats concurrent edit.
- Child collections (splits) → additive merge; total mismatch → recompute equal split + flag for Owner review.

**Retry:** exponential backoff (2s → 8s → 30s → 2m, capped); after max attempts mark `failed` and expose manual retry. Failures never block the UI.

**Reconciliation (pull):** Realtime/initial-sync changes are upserted into Drift by `serverId`; Drift re-emits to UI. A delta `since` cursor (per table `updatedAt`) bounds initial sync.

---

## 7. Supabase Architecture

**Responsibilities:** durable storage (Postgres), identity (Auth), change propagation (Realtime), binary storage (receipts), and privileged logic (Edge Functions).

**Boundaries:**
- Client uses the Supabase Dart SDK **only inside remote data sources**.
- **Tenant isolation** enforced by RLS keyed on trip membership (see §15) — the client never trusts itself for authorization.
- **Edge Functions** own all logic that must not run on the client:
  - FCM dispatch (notification fan-out).
  - AI proxy to OpenRouter (key never on device — §11).
  - Settlement validation / heavy aggregation if needed server-side.
  - Invite acceptance side-effects (membership creation under controlled checks).
- **Computed/derived data** (budget spent/remaining, settlement graph) is computed **client-side** from synced rows for responsiveness; server may recompute for report integrity.

**Migrations:** managed via Supabase migration files in repo; applied per environment through CI (§18).

---

## 8. Authentication Flow

**Mechanics (architecture, not UX):**
- Supabase Auth issues a JWT access token + refresh token. Tokens stored in `flutter_secure_storage`; Supabase SDK manages auto-refresh.
- `authStateProvider` exposes a stream of `(session, user)`; it drives GoRouter redirects and repository availability.
- **Providers:** Google & Apple via OAuth/native sign-in → Supabase identity; Email/password and Phone OTP via Supabase Auth directly.
- **FCM registration:** on successful auth, device token is registered (stored server-side, scoped to user) for push targeting; de-registered on logout.
- **Session resume:** on cold start, SDK restores session from secure storage; offline, the cached session authorizes local reads/writes (sync deferred).
- **Token expiry mid-session:** silent refresh; on hard failure → 401 path routes to Auth preserving deep-link intent.
- **Multi-device:** independent sessions; Realtime + sync keep Drift caches convergent.

---

## 9. Realtime Architecture

- **Channel model:** subscribe **per active trip** (channel scoped to `tripId`) rather than globally, to bound payload and respect RLS.
- **Subscriptions:** Postgres change events (insert/update/delete) on trip-scoped tables (expenses, members, settlements, trip).
- **Ingestion:** Realtime events are **not** rendered directly. The reconciler upserts the change into Drift (by `serverId`); Drift's reactive query re-emits to UI. This keeps one rendering path (Drift) online and offline.
- **Lifecycle:** subscribe on trip-open, unsubscribe on trip-close/background to conserve sockets; resubscribe on foreground/connectivity.
- **Ordering & gaps:** Realtime is best-effort; a lightweight **catch-up pull** (delta `since` cursor) runs on (re)subscribe to fill any missed events.
- **Echo suppression:** local-origin changes (matched by idempotency key/localId) are ignored to avoid flicker/duplicates.
- **Presence/typing:** out of scope (no chat in v1.0).

---

## 10. Storage Architecture (Receipts)

- **Bucket:** a private Supabase Storage bucket for receipts; objects pathed by `tripId/expenseId/uuid` so RLS/path policies align with trip membership.
- **Offline-first upload:** receipt image is captured and **stored locally first** (file path in Drift, `uploadStatus = pending`); the expense is fully usable without the remote object.
- **Upload pipeline:** Sync Engine uploads pending receipts after the parent expense has a `serverId`; on success, store the object path and set `uploaded`; on failure, backoff-retry (§6).
- **Access:** reads use signed URLs (short-lived) generated on demand; URLs are never persisted long-term.
- **Constraints:** ≤10MB, jpg/png/heic; client-side downscale/compress before upload to control bandwidth and latency.
- **Cleanup:** soft-deleting an expense marks the receipt for deletion; a server-side job (Edge Function/cron) purges orphaned objects after the 30-day recovery window.

---

## 11. AI Integration Architecture (v1.5)

- **Proxy pattern:** the device **never** holds the OpenRouter key. All AI calls go through a Supabase **Edge Function** that injects the key, enforces rate limits, and shapes prompts.
- **Request path:** Client → Edge Function (`/ai/categorize`, `/ai/insights`) → OpenRouter → response → client. Categorization is synchronous (low latency); insights/budget-analysis run **async** and write results back for the client to pick up via sync/Realtime.
- **Determinism & safety:** prompts constrain output to the fixed category enum; payloads are PII-minimized (no names/emails — only description + amount + category list).
- **Confidence handling:** Edge Function returns a normalized confidence; client applies thresholds (auto-apply ≥0.75, suggest ≥0.4, ignore below) — policy lives client-side so it's tunable without redeploying functions.
- **Fallback:** any timeout/error → client silently falls back to manual categorization; AI never blocks the write path.
- **Caching:** normalized `description → category` results cached in Drift (30-day TTL per trip); insights cached until the next material expense change. Edge Function may add a server-side cache for popular descriptions.
- **Provider abstraction:** model selection (Gemini/Claude/GPT) is a server-side config; client is model-agnostic.

---

## 12. Repository Pattern

- **One repository interface per feature**, defined in the feature's `domain`. Implementations live in `data`.
- **Repository owns the local/remote decision.** It writes to Drift, enqueues sync, and exposes Drift streams. Remote sources are an internal detail.
- **Return type:** `Result<T, Failure>` (sealed) — **no exceptions cross the repository boundary**. Data sources may throw; the repo catches and maps to typed `Failure`.
- **Mappers:** explicit mappers convert between Drift rows, remote DTOs, and domain entities. Domain entities are `freezed`, immutable, and infrastructure-agnostic.
- **Composition:** a repository depends on (a) a Drift DAO, (b) a remote data source, (c) the sync engine. It does not depend on other repositories' data layers.
- **Read contract:** read methods return `Stream<T>` (from Drift). Write methods return `Future<Result<T>>` and complete after the **local** commit (not after sync).

---

## 13. Error Handling Strategy

- **Typed failures:** a sealed `Failure` hierarchy — `NetworkFailure`, `AuthFailure`, `PermissionFailure`, `ValidationFailure`, `ConflictFailure`, `StorageFailure`, `QuotaFailure`, `AiFailure`, `UnknownFailure`.
- **Boundaries:**
  - Data sources throw/translate raw errors → repo maps to `Failure`.
  - Controllers convert `Result` → `AsyncValue` (error state) for the UI.
  - Shared UI components render standard **loading / empty / error** states (`core/widgets`).
- **Global safety net:** run app in a guarded zone + `FlutterError.onError` + `PlatformDispatcher.onError` → log + report; never crash silently.
- **Offline is not an error:** connectivity loss degrades gracefully (banner + queued writes), not an error dialog.
- **User-facing mapping:** each `Failure` maps to a concise message + recommended action (retry, re-auth, upgrade). Severity decides banner vs. inline vs. blocking.
- **Idempotency on retry:** all retryable mutations are safe to replay (keys), so error-driven retries can't duplicate data.

---

## 14. Logging & Analytics

**Logging:**
- Structured logger with levels (`debug/info/warn/error`); level gated per flavor (verbose in dev, warn+ in prod).
- **Sinks:** console (dev), crash/error reporter (prod). No PII in logs — IDs only.
- Tag logs by domain (`sync`, `auth`, `realtime`, `ai`) for filtering.

**Analytics:**
- A single `AnalyticsService` (provider) with **typed event contracts** mirroring PRD §14; widgets/controllers call typed methods, never raw strings.
- **Offline buffering:** events persist to Drift when offline and flush on reconnect (ordered).
- **No PII:** properties carry IDs and enums only.
- **Separation:** analytics (product metrics) and logging (diagnostics) are distinct sinks; crash reporting is its own pipeline.

---

## 15. Security (RLS, Auth, Storage)

- **Row-Level Security (authoritative):** every trip-scoped table enforces RLS so a user can only read/write rows for trips they are an active member of; **role checks** (Owner-only actions) enforced in RLS policies, not just client UI. The client UI mirroring permissions (§ PRD 6) is a UX convenience, not the security boundary.
- **Auth:** short-lived JWT + refresh; tokens in secure storage; auto-refresh; logout revokes device FCM token and clears local secrets.
- **Storage policies:** receipts bucket is private; path-based policies tie objects to trip membership; access via short-lived signed URLs only.
- **Secrets:** no third-party keys (OpenRouter, FCM server key) on device — they live in Edge Functions / server config. Client holds only the Supabase anon key (public by design) and user session.
- **Privileged logic:** membership creation on invite-accept, notification fan-out, and AI calls run in Edge Functions with service role, behind validation — never directly client-authorized.
- **Transport:** TLS everywhere; certificate handling via platform defaults.
- **Input safety:** validation at controller + repo; server-side constraints as the backstop.

---

## 16. Performance Strategy

- **<300ms perceived render:** UI always renders from Drift cache first; network is background. No screen blocks on remote calls.
- **Reactive, scoped queries:** Drift queries are narrowed (by `tripId`, pagination/limits) so streams stay small; avoid whole-table watches.
- **List virtualization:** lazy lists for expenses/reports; paginate large trips.
- **Image discipline:** downscale/compress receipts before storage; cache thumbnails; signed-URL caching within TTL.
- **Realtime economy:** per-trip channels, subscribe on demand, unsubscribe on background.
- **Build performance:** `const` widgets, `select`-based Riverpod watches to minimize rebuilds, code-gen providers.
- **Cold start:** defer non-critical init (analytics flush, AI warmup) until after first frame.
- **Sync batching:** debounce queue drains; batch related items in one round-trip where possible.

---

## 17. Scalability Plan

- **Client scale:** offline-first means client cost is bounded by **active trip** size, not total user data. Archived/old trips are lazily loaded, not held resident.
- **Backend scale:** Postgres + Supabase scales vertically/horizontally; RLS keeps queries trip-scoped (indexed on `tripId`). Heavy aggregation pushed to Edge Functions / scheduled jobs, not request-time.
- **Realtime scale:** per-trip channels cap fan-out; no global firehose. Catch-up pulls absorb missed events so we don't need at-least-once delivery guarantees from Realtime.
- **AI scale (v1.5):** server-side caching + rate limiting in the Edge proxy; model choice tunable server-side to balance cost/latency.
- **Storage scale:** object paths partitioned by trip; lifecycle/cleanup jobs prevent unbounded growth.
- **Future web (v3.0):** the domain/repository layer is platform-agnostic; a web client reuses domain + remote sources, swapping Drift for an appropriate web persistence layer.

---

## 18. Deployment Architecture

- **Mobile delivery:** Flutter builds per flavor → Play Store (Android) and App Store (iOS); staged rollouts; crash-free gates before full rollout.
- **Backend delivery:** Supabase project per environment; **migrations and Edge Functions deployed via CI** on merge to the corresponding branch.
- **CI/CD pipeline:** lint → analyze → unit/widget tests → build flavors → (on tag) store upload + backend deploy. Edge Functions and migrations versioned in the same repo.
- **Release flow:** `dev → staging → prod`; backend changes promoted with the client release they support; backward-compatible migrations (expand-then-contract) to keep older clients working during rollout.
- **Push (FCM):** server key configured in environment/Edge Function secrets; topic/token strategy per user.
- **Rollback:** store phased-rollout halt + backend migration down-paths / point-in-time recovery.

---

## 19. Environment Configuration

- **Flavors:** `dev`, `staging`, `prod` — distinct app IDs, icons, and Supabase projects.
- **Config injection:** compile-time via `--dart-define` (Supabase URL/anon key, flavor, log level, feature flags); no secrets baked into source.
- **Single config surface:** a typed `AppConfig` (in `core/config`) reads dart-defines; the rest of the app depends on `AppConfig`, never raw env reads.
- **Feature flags:** gate v1.5 (AI), v2.0 features behind flags so code can merge ahead of release.
- **Secrets handling:** only the Supabase anon key (public) on client; all privileged keys in Supabase/Edge Function secrets per environment.
- **Local dev:** optional Supabase local stack; seed scripts for test trips/members.

---

## 20. Engineering Guidelines

1. **Domain boundary is sacred:** UI never imports Supabase/Drift. Go through repositories.
2. **Local-first:** every write commits to Drift and returns before sync. Never await the network in the UI path.
3. **No exceptions across boundaries:** repositories return `Result`/`Failure`. Catch and map at the data-source edge.
4. **Immutable domain models:** `freezed` entities; map explicitly between layers.
5. **Reactive reads:** UI watches Drift streams; remote changes land in Drift, then UI — one rendering path.
6. **Idempotent mutations:** every create/update carries an idempotency key; retries must be safe.
7. **Typed everything:** typed routes, typed analytics events, typed config — no magic strings.
8. **Provider hygiene:** code-gen providers, `autoDispose` for transient state, family-scope by `tripId`, `select` to minimize rebuilds.
9. **Feature isolation:** cross-feature use only via the other feature's `domain` interface.
10. **Security is server-side:** never rely on client checks for authorization — RLS and Edge Functions are the boundary; client checks are UX only.
11. **Offline ≠ error:** degrade gracefully; queue and inform, don't block or alarm.
12. **Tests:** unit-test repositories (with fake sources) and sync/conflict logic; widget-test controllers' loading/error/empty states.
13. **No secrets on device.** If a key must stay secret, it belongs in an Edge Function.
14. **Observability by default:** log with domain tags, emit the typed analytics event, handle the failure — every mutation does all three.

---

*This document defines how TripMate is built. It pairs with PRD v2.0 (what to build). Changes to architecture should be versioned here and reviewed before implementation.*
