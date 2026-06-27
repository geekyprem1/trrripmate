# TripMate — Claude Code Development Rules

**These rules are MANDATORY.** Claude Code MUST follow every rule when generating, editing, or reviewing code for TripMate. When a request conflicts with a rule, STOP and flag it — do not silently violate a rule.

**Companion specs (source of truth):** Product Vision · PRD v2.0 · Technical Architecture v1.0 · Database Design v1.0 · Backend API Contracts v1.0 · UI/UX Spec v1.0 · Design System v1.0.

**Rule precedence:** Security > Data correctness > Architecture > Style. If two rules conflict, the higher category wins.

---

## 1. Folder Structure (Feature-First)

- MUST follow the structure in Technical Architecture §3. Do not invent top-level folders.
```
lib/
  app/        # MaterialApp, router, theme
  core/       # config, error, network, sync, database, logging, analytics, widgets
  features/<feature>/{data,domain,presentation}/
  shared/     # cross-feature models, extensions
```
- Each feature owns `data/`, `domain/`, `presentation/`. NO other layout.
- `core/` and `shared/` MUST NOT import from `features/`.
- A feature MUST NOT import another feature's `data/` or `presentation/` — only its `domain/` (entities + repository interface).
- One public concern per file. No "god files" / barrel files that re-export entire layers.

---

## 2. Naming

- **Files:** `snake_case.dart` (e.g., `add_expense_controller.dart`).
- **Classes/enums/typedefs:** `PascalCase`. **Members/vars:** `camelCase`. **Constants:** `camelCase` (no `SCREAMING_CASE`).
- **Providers:** suffix by role — `...Repository`, `...Controller`, `...StreamProvider`, `...Service`.
- **Riverpod generated providers:** function name = provider name (e.g., `expenseListController`).
- **Domain entities:** noun, no suffix (`Trip`, `Expense`). **DTOs:** `...Dto`. **Drift rows:** `...Row`/Drift-generated. **Mappers:** `...Mapper`.
- **Booleans:** `is/has/can/should` prefix. **Async:** verb-first (`loadTrips`, `submitExpense`).
- DB fields stay `snake_case` to match Postgres/PostgREST; Dart models map to `camelCase` via explicit mappers.
- NO abbreviations except well-known (`id`, `url`, `db`). No `data1`, `tmp`, `flag`.

---

## 3. Architecture Rules

- **Strict layering:** UI → Controller → Repository → (Drift | Remote) → Sync. NEVER skip layers.
- UI/widgets MUST NOT import `supabase`, `drift`, or any data source directly. Go through repositories.
- Controllers contain orchestration only; NO business invariants in widgets, NO networking in widgets.
- Domain layer is pure Dart: no Flutter, no Supabase, no Drift imports in `domain/`.
- Dependencies point inward only: `presentation → domain ← data`. `domain` depends on nothing external.
- All cross-layer data crossing uses **domain entities** (immutable), never DTOs or Drift rows.
- **Local-first:** every write commits to Drift first and returns BEFORE any network call. Never `await` the network in a UI action path.

---

## 4. Riverpod Rules

- Use **riverpod v2 with code generation** (`@riverpod`). NO manual `StateProvider`/`ChangeNotifierProvider` for app state.
- Reads: UI `ref.watch`es Drift-backed **stream providers**. Writes/actions: `ref.read(controller.notifier)`.
- Use `AsyncNotifier`/`Notifier`; expose `AsyncValue` for loading/error/data — handle ALL three in UI.
- Trip-scoped providers MUST be **families** keyed by `tripId`. Use `autoDispose` for transient/screen state (forms, drafts).
- Use `select` to scope rebuilds. NO whole-object watches when a field suffices.
- NO business logic, no I/O, no `BuildContext` inside providers' build beyond wiring.
- NO global mutable singletons outside Riverpod. Infrastructure (Supabase client, Drift db, sync engine) are providers.
- Never create providers inside `build()` of widgets. Never `ref.read` in `build` for reactive data.

---

## 5. Repository Rules

- One **repository interface per feature** in `domain/`; implementation in `data/`.
- Methods returning data: `Stream<Entity>` from Drift (reactive). Methods performing mutation: `Future<Result<T>>`, completing after the **local** commit (not after sync).
- Repository OWNS the local/remote/sync decision. Callers never know about Supabase or Drift.
- **NO exceptions cross the repository boundary.** Catch at the data-source edge; map to a typed `Failure`; return `Result`.
- Explicit mappers between Drift row ↔ DTO ↔ entity. NO leaking `Map<String,dynamic>` upward.
- Every create/update carries an `idempotencyKey`; every update sends `expectedVersion` for optimistic concurrency.
- Repositories depend only on their own DAO, remote source, and the sync engine — never on another repository's data layer.

---

## 6. Error Handling

- Use a **sealed `Failure`** hierarchy: `NetworkFailure`, `AuthFailure`, `PermissionFailure`, `ValidationFailure`, `ConflictFailure`, `StorageFailure`, `QuotaFailure`, `AiFailure`, `UnknownFailure`.
- Use a `Result<T>` (sealed success/failure) return type for all repo mutations. NO `throw` for control flow across boundaries.
- Map API error codes (Backend Contracts §13) to `Failure` types in the remote source.
- UI renders standard **loading / empty / error** states from `core/widgets`. NEVER leave a dead end — error states MUST offer retry where retryable.
- **Offline is NOT an error.** Degrade gracefully (banner + queue), never an error dialog for connectivity.
- Global guards required: `runZonedGuarded` + `FlutterError.onError` + `PlatformDispatcher.onError` → log + report. No silent catches (`catch (_) {}` is forbidden unless commented with justification).
- `AI_TIMEOUT` is a successful fallback, not a blocking error.

---

## 7. Testing Rules

- **Required coverage:** every repository, every sync/conflict path, every controller's loading/error/empty/data states, every validation rule.
- Repositories tested with fake local + remote sources (no real network/DB).
- Sync engine: test queue ordering, ID handling, idempotent replay, conflict resolution (LWW, delete-wins, split-merge).
- Validation invariants tested explicitly: `amount>0`, `Σ splits = amount`, settlement nets to zero, free-tier limit.
- Widget tests for each screen's state matrix (offline/loading/error/empty/content).
- NO test depends on live Supabase. Use fakes/mocks; integration tests gated behind a flag with a local stack.
- New feature code WITHOUT tests is incomplete — do not mark a task done without them.
- Tests are deterministic: no real timers/sleeps (use fake clocks), no network, no random without seed.

---

## 8. Git Rules

- **Never commit or push unless explicitly asked.** If on `main`/`master`, create a branch first.
- Branch naming: `feature/<scope>`, `fix/<scope>`, `chore/<scope>`.
- Conventional Commits: `feat(expenses): ...`, `fix(sync): ...`, `refactor:`, `test:`, `docs:`, `chore:`.
- Small, focused commits — one logical change each. NO mixing refactor + feature in one commit.
- NEVER commit secrets, `.env`, keys, or service-role tokens. `.gitignore` MUST cover them.
- Do NOT skip hooks (`--no-verify`) or bypass signing unless the user explicitly asks.
- End commit messages with the required co-author trailer:
  `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`
- Never force-push shared branches. Prefer new commits over amending pushed history.

---

## 9. Code Style

- Enforce `flutter_analyze` + `flutter_lints` (or `very_good_analysis`). Zero analyzer warnings on submitted code.
- `dart format` (no manual formatting). Line length default (80) unless project config overrides.
- Sound null safety: NO `!` bang operator except where provably non-null with a comment; NO `late` unless justified.
- Prefer `final`/`const`; immutable by default. Use `const` constructors wherever possible.
- Use `freezed` for entities/DTOs/unions; `json_serializable` for JSON. NO hand-written `copyWith`/`==`.
- No magic numbers/strings — use design tokens, named constants, and typed enums.
- Small functions, early returns, no deep nesting (>3 levels → refactor). One responsibility per class/function.
- NO commented-out code, NO dead code, NO `print` (use the logger). Doc-comment public APIs.

---

## 10. Performance Rules

- Render from Drift cache first; network is background. Target <300ms perceived per screen (Architecture §16).
- Drift queries MUST be scoped (by `tripId`, with `limit`/pagination). NO whole-table watches.
- Lists MUST be lazy/virtualized (`ListView.builder`/slivers). Paginate large datasets (keyset, default limit 50).
- `const` widgets everywhere applicable; `select`-based watches; avoid rebuilding subtrees.
- Downscale/compress receipt images before upload (≤10MB, target far smaller). Cache thumbnails; signed URLs within TTL.
- Defer non-critical init (analytics flush, AI warmup) until after first frame.
- NO heavy work on the UI isolate — use isolates/`compute` for PDF generation, large parsing.
- Debounce rapid actions (search, sync drains); idempotency prevents duplicate writes from double-taps.

---

## 11. Flutter Best Practices

- Material 3 only; consume Design System tokens — NO raw hex, font sizes, or dp literals in widgets.
- Use `GoRouter` with typed routes; NO raw string paths in widgets; auth/permission guards via router redirects.
- Stateless widgets by default; state lives in Riverpod, not `StatefulWidget`, unless purely local (animation controllers).
- NO `BuildContext` across async gaps without `context.mounted` check.
- Extract widgets when build methods exceed ~3 nested children or are reused; NO 300-line build methods.
- Accessibility is mandatory (UI/UX §5 / Design System §17): semantic labels, ≥48dp targets, dynamic type, color+icon+label for status, chart text equivalents.
- Handle all four UI states per screen: offline, loading, error, empty.
- Respect reduced-motion; transitions ≤300ms.

---

## 12. Supabase Rules

- Client uses the Supabase SDK ONLY inside `data/` remote sources. NEVER in UI/controllers/domain.
- Choose the lowest-privilege surface (Backend Contracts §1): PostgREST for simple RLS CRUD → RPC for transactions/invariants → Edge Function for privileged/secret logic.
- Mutations with invariants (expense+splits, settlement) MUST go through the defined **RPCs**, not raw table writes.
- NEVER trust the client for authorization — RLS is the boundary. Client permission checks are UX only.
- NO service-role key on the device, EVER. Privileged work happens in Edge Functions.
- Use client-generated UUIDs for new rows (offline-first). Send `idempotencyKey` on creates, `expectedVersion` on updates.
- Reads default-filter `deleted_at is null`. Realtime subscriptions scoped per `tripId`; ingest events into Drift, never render directly.

---

## 13. Security Rules

- NO secrets in source, logs, analytics, or commits. Third-party keys (OpenRouter, FCM) live ONLY in Edge Functions / env. Client holds only the Supabase anon key + user session.
- Tokens stored in `flutter_secure_storage`. NO tokens in `SharedPreferences`/plain storage/logs.
- NEVER log PII (names, emails, phone, amounts tied to identity). Logs use IDs only.
- Authorization is server-side (RLS + RPC/Edge checks). Do not implement client-only gating as a security control.
- Validate ALL input at controller + repository; treat server constraints as the backstop.
- Receipts bucket is private; access via short-lived signed URLs only — never persist long-lived URLs.
- AI payloads are PII-minimized (description + amount + category list only). No names/emails to the model.
- Use parameterized RPC params; never build SQL/filters from unsanitized user strings.

---

## 14. Offline Rules

- Every mutation: write Drift (local UUID) → enqueue `SyncQueueItem` → return. UI updates from the Drift stream.
- Sync engine drains FIFO, **dependency-ordered** (Trip → Member/Expense → Split/Receipt). Children wait for parents.
- Conflict resolution is centralized in ONE module: scalars = last-write-wins by `updatedAt`; delete beats edit; split sets = additive merge, mismatch → recompute equal split + flag.
- Retry with exponential backoff (2s→8s→30s→2m, capped); after max attempts mark `failed` + expose manual retry. Failures NEVER block the UI.
- All retryable mutations MUST be idempotent (idempotency keys). Replays must not duplicate.
- Pending/failed sync state is surfaced in UI (badges), never hidden.
- Reads ALWAYS work offline from cache. Writes ALWAYS allowed offline (except auth, invite create/accept, purchases — show "needs connection").

---

## 15. AI Rules (v1.5)

- ALL AI calls go through the Edge Function proxy. NEVER call OpenRouter directly from the client. NEVER embed the AI key.
- AI is **assistive, never blocking**: categorization is a suggestion; expense save MUST succeed without AI.
- Apply confidence thresholds client-side: auto-apply ≥0.75, suggest ≥0.4, ignore below. User can always override.
- Timeout/error → silent fallback to manual category. `AI_TIMEOUT` returns a fallback payload (not an error).
- Cache results (normalized description → category, 30-day TTL; insights until next material expense change).
- Constrain model output to the fixed category enum — no free-text categories. PII-minimized payloads only.
- AI features gated behind Premium entitlement and rate limits; handle `AI_RATE_LIMITED` gracefully.
- Keep AI data in separate tables/providers — never coupled into the core financial write path.

---

## 16. Definition of Done (per change)

A change is COMPLETE only when ALL hold:
1. Follows layering, naming, and folder rules (§1–§5).
2. Returns `Result`/`Failure`; no exceptions across boundaries (§6).
3. Handles offline + loading + error + empty UI states (§6, §11, §14).
4. Has tests for logic, validation, and state matrix (§7).
5. Zero analyzer warnings; `dart format` clean; no `print`/dead code (§9).
6. No secrets, no PII in logs, server-side authz respected (§13).
7. Uses Design System tokens, accessible, Material 3 (§11).
8. Offline-safe and idempotent where it writes (§14).

**If any rule cannot be satisfied, STOP and surface the conflict to the user instead of generating non-compliant code.**
