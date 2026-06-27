# TripMate — Implementation-Ready PRD

**Version:** 2.0 (Implementation-Ready)
**Status:** Ready for Engineering
**Last Updated:** 2026-06-26
**Owner:** Prem (geekyprem4@gmail.com)
**Source:** Product Vision Document v1.0
**Audience:** Engineering, Design, QA, Claude Code

> **Inconsistency resolved:** AI features (categorization, insights, budget analysis, suggestions) are scheduled for **v1.5**, not v1.0. In **v1.0 MVP, categorization is manual** (user picks from a fixed category list). This removes the MVP-vs-roadmap contradiction in the source vision.

---

## 1. Product Overview

### 1.1 Vision
Become the world's easiest travel expense management platform — an AI-first, collaborative tool built specifically for trips, covering the full lifecycle from planning to final settlement.

### 1.2 Mission
Make group travel finances effortless. No calculations. No confusion. No arguments.

### 1.3 Goals
- **G1** — Let a group create a trip, invite members, and start tracking in under 2 minutes.
- **G2** — Keep every common action within a maximum of 2 taps.
- **G3** — Work fully offline; sync transparently on reconnect.
- **G4** — Produce a fair, unambiguous settlement ("who pays who") at any time.
- **G5** — Deliver exportable reports (PDF in v1.0) for every trip.
- **G6** — Achieve <300ms perceived screen render and >99.5% crash-free sessions.

### 1.4 Non-Goals (v1.0)
- ❌ Hotel booking · ❌ Flight booking · ❌ Maps · ❌ In-app chat · ❌ Social feed · ❌ Travel blogging
- ❌ AI features (moved to v1.5) · ❌ Multi-currency conversion (future) · ❌ Web app (v3.0)

### 1.5 Success Metrics (6 months post-launch)
| Metric | Target |
|--------|--------|
| Downloads | 50K |
| Active Users (MAU) | 10K |
| Trips Created | 100K |
| Expenses Logged | 500K |
| App Store Rating | 4.7★ |
| Crash-Free Sessions | >99.5% |
| Screen render (p95) | <300ms |
| Offline-add → sync success | >99% |

---

## 2. User Personas

### 2.1 Prem — The Organizer (Age 28)
- **Goals:** Run the trip's money cleanly; get a clear final report; never look like the "bad guy" chasing payments.
- **Pain Points:** Manual spreadsheets; expenses scattered across apps; disputes at settlement.
- **Behaviour:** Creates the trip, sets the budget, invites everyone, approves expenses, exports the report.
- **Primary Tasks:** Create trip · Invite members · Approve/reject expenses · View budget · Run settlement · Export PDF · Archive.

### 2.2 Rahul — The Contributor (Age 25)
- **Goals:** Add what he spent quickly and forget about it until settlement.
- **Pain Points:** Forgets to log expenses; loses receipts; unsure who owes what.
- **Behaviour:** Adds expenses on the go (often offline, e.g., petrol pump, toll), attaches receipt photos, relies on reminders.
- **Primary Tasks:** Add expense · Attach receipt · Edit own expense · View remaining budget · See his share.

### 2.3 Amit — The Settler (Age 30)
- **Goals:** Know exactly what he owes and to whom; pay once, cleanly, after the trip.
- **Pain Points:** Doesn't track during the trip; needs a single source of truth at the end.
- **Behaviour:** Mostly passive during the trip; engages at settlement; marks payments done.
- **Primary Tasks:** View settlement · See pending dues · Mark payment completed · View report.

---

## 3. Complete User Flows

> Notation: each step is sequential. Branches noted with **[Alt]**. Offline noted with **[Offline]**.

### 3.1 Authentication
1. User opens app → Splash → Auth screen.
2. User selects method: Google · Apple (iOS) · Email · Phone OTP.
3. **[Email]** Enter email + password → submit → verify → home.
4. **[Phone OTP]** Enter phone → receive OTP → enter OTP → verify → home.
5. **[Google/Apple]** OAuth consent → token exchange → home.
6. First-time users complete profile (name, avatar optional) → home.
7. **[Alt: failure]** Show error state (see §13); allow retry.

### 3.2 Create Trip
1. Home → tap "Create Trip" (FAB).
2. Enter trip name (required), destination (optional), start/end dates (optional), currency (default device locale), total budget (optional).
3. Tap "Create".
4. Creator becomes **Owner**; trip appears at top of trip list. **[Offline]** Created locally, queued for sync.
5. Prompt: "Invite members?" → routes to Invite flow.

### 3.3 Invite Members
1. Open trip → Members tab → tap "Invite".
2. Generate a share invite (link/code). **[Alt]** Enter email or phone to send directly.
3. Owner shares link via system share sheet.
4. Invitation created with status `pending` and expiry (default 7 days).
5. **[Offline]** Invite generation requires connectivity; if offline, show "Will send when online" and queue.

### 3.4 Join Trip
1. Invitee opens invite link/code → app opens (or store if not installed).
2. If not authenticated → Auth flow → returns to invite.
3. Show trip preview (name, owner, member count).
4. Tap "Accept" → becomes **Member**; invitation status → `accepted`. **[Alt]** Tap "Reject" → status `rejected`.
5. **[Alt: expired]** Show "Invitation expired"; offer to request a new one.
6. Member lands on trip dashboard.

### 3.5 Add Expense
1. Open trip → tap "Add Expense" (FAB).
2. Enter amount (required, >0), select category (required), Paid By (required, default = current user), split members (required, default = all members, equal split).
3. Optional: attach receipt photo, add notes, set date.
4. Tap "Save" → shows loading → expense created.
5. If approval required: status `pending` until Owner approves; otherwise counts immediately.
6. Budget dashboard updates instantly (realtime for online members). **[Offline]** Saved locally, queued; dashboard updates locally.

### 3.6 Edit Expense
1. Open expense detail → tap "Edit" (Owner, or author for own expense).
2. Modify fields → "Save".
3. If previously approved and amount/split changes → status returns to `pending` (re-approval). 
4. Budget recalculates; realtime update broadcast. **[Offline]** Queued; conflict handled per §9.

### 3.7 Delete Expense
1. Open expense detail → "Delete" (Owner only).
2. Confirm dialog.
3. Soft-delete (marked deleted, recoverable for 30 days); budget recalculates.
4. Realtime removal for other members. **[Offline]** Queued.

### 3.8 Settlement
1. Open trip → Settlement tab.
2. System computes net balances per member (paid − owed) and minimal "who pays who" transactions.
3. Display pending settlements list.
4. Payer/Owner marks a transaction "Paid" → status `completed`. 
5. When all completed → trip is "Settled". **[Offline]** Marking paid is queued.

### 3.9 Reports
1. Open trip → Reports tab.
2. Select filters (date range, member, category).
3. View category breakdown, pie chart, bar chart, timeline.
4. Tap "Export PDF" → generate → share/save. **[Offline]** Report viewing works on cached data; export requires local render only (no network).

### 3.10 Archive Trip
1. Open trip → settings → "Archive" (Owner only).
2. Confirm. Trip becomes read-only and moves to Archived list.
3. **[Alt]** Owner can "Unarchive" to restore to active. **[Offline]** Queued.

---

## 4. Functional Requirements

> Priority: **P0** = MVP-blocking, **P1** = MVP-important, **P2** = nice-to-have/next.
> Each requirement is self-contained and actionable.

### 4.1 Authentication

#### REQ-AUTH-01 — Multi-method Sign In
- **Description:** Authenticate via Google, Apple (iOS), Email/password, or Phone OTP.
- **Priority:** P0
- **Dependencies:** Auth provider (Supabase Auth); FCM token registration post-login.
- **Business Rules:** One account per verified email/phone; Apple sign-in mandatory on iOS if other social logins present.
- **Validation:** Valid email format; password ≥8 chars; OTP 6 digits, expires in 5 min; max 5 OTP attempts.
- **Permissions:** Public (unauthenticated).
- **Offline:** Sign-in requires connectivity; previously authenticated session persists offline via cached token.
- **Realtime:** N/A.
- **Failure:** Wrong OTP/credentials → inline error + retry; network failure → "No internet" state.
- **Success:** Session created, token cached, routed to home; FCM token saved.
- **Acceptance Criteria:** All four methods work; session persists across app restarts; logout clears session.
- **Edge Cases:** OTP resend throttling; account exists with different provider; expired token auto-refresh; multiple devices.

#### REQ-AUTH-02 — Session & Logout
- **Description:** Persist session; allow logout.
- **Priority:** P0 · **Dependencies:** REQ-AUTH-01.
- **Business Rules:** Logout clears local cache except unsynced queue warning.
- **Validation:** Confirm logout if unsynced items exist.
- **Permissions:** Authenticated user.
- **Offline:** Logout allowed offline; warns about pending unsynced data.
- **Failure:** N/A. · **Success:** Returns to Auth screen.
- **Acceptance Criteria:** Session survives restart; logout removes tokens.
- **Edge Cases:** Logout with pending sync queue; token revoked server-side.

### 4.2 Trips

#### REQ-TRIP-01 — Create Trip
- **Description:** Create a trip with name, optional destination/dates/budget/currency.
- **Priority:** P0 · **Dependencies:** REQ-AUTH-01.
- **Business Rules:** Creator = Owner; free tier limited to **3 active trips**.
- **Validation:** Name required (1–60 chars); end date ≥ start date; budget ≥0.
- **Permissions:** Any authenticated user.
- **Offline:** Created locally, queued; gets server ID on sync.
- **Realtime:** Appears for invited members on sync.
- **Failure:** Free-tier limit reached → upsell prompt; sync failure → stays queued.
- **Success:** Trip in active list; user is Owner.
- **Acceptance Criteria:** Trip created offline and online; 4th active trip blocked on free tier.
- **Edge Cases:** Duplicate-tap creating two trips; offline create then quota exceeded on sync.

#### REQ-TRIP-02 — Edit Trip
- **Description:** Edit trip metadata and budget.
- **Priority:** P0 · **Dependencies:** REQ-TRIP-01.
- **Business Rules:** Owner only; budget edits recalculate remaining.
- **Validation:** Same as create.
- **Permissions:** Owner.
- **Offline:** Queued. · **Realtime:** Broadcast to members.
- **Failure:** Conflict → §9. · **Success:** Updated metadata everywhere.
- **Acceptance Criteria:** Member cannot edit; budget change updates dashboard.
- **Edge Cases:** Lowering budget below already-spent amount → allowed but flagged "Over budget".

#### REQ-TRIP-03 — Delete Trip
- **Description:** Soft-delete a trip.
- **Priority:** P1 · **Dependencies:** REQ-TRIP-01.
- **Business Rules:** Owner only; soft-delete, recoverable 30 days; cascades to expenses/settlements (also soft).
- **Validation:** Confirmation required; warn if unsettled balances exist.
- **Permissions:** Owner.
- **Offline:** Queued. · **Realtime:** Removed for members.
- **Failure:** Conflict → §9. · **Success:** Trip gone from all lists.
- **Acceptance Criteria:** Member cannot delete; recoverable within 30 days.
- **Edge Cases:** Delete with pending settlements; restore after partial member changes.

#### REQ-TRIP-04 — Archive / Unarchive Trip
- **Description:** Make trip read-only; restore to active.
- **Priority:** P1 · **Dependencies:** REQ-TRIP-01.
- **Business Rules:** Owner only; archived trips don't count toward free-tier active limit.
- **Validation:** None beyond confirm.
- **Permissions:** Owner.
- **Offline:** Queued. · **Realtime:** State broadcast.
- **Failure:** §9. · **Success:** Trip moves between Active/Archived.
- **Acceptance Criteria:** Archived trip is read-only; unarchive restores edits.
- **Edge Cases:** Add expense attempt while archived → blocked; unarchive past free-tier limit → upsell.

### 4.3 Members

#### REQ-MEM-01 — Invite Member
- **Description:** Invite via shareable link/code or direct email/phone.
- **Priority:** P0 · **Dependencies:** REQ-TRIP-01.
- **Business Rules:** Owner only; invitation expires in 7 days; one pending invite per invitee per trip.
- **Validation:** Valid email/phone if direct; expiry enforced.
- **Permissions:** Owner.
- **Offline:** Queued (requires connectivity to deliver).
- **Realtime:** Member appears on accept.
- **Failure:** Delivery failure → retryable; duplicate invite → reuse existing pending.
- **Success:** Invitation `pending` created and shareable.
- **Acceptance Criteria:** Member cannot invite; expired invite cannot be accepted.
- **Edge Cases:** Inviting an existing member; inviting self; invite after archive (blocked).

#### REQ-MEM-02 — Accept / Reject Invitation
- **Description:** Invitee joins or declines.
- **Priority:** P0 · **Dependencies:** REQ-MEM-01, REQ-AUTH-01.
- **Business Rules:** Accept → role Member; reject → terminal.
- **Validation:** Invite must be `pending` and not expired.
- **Permissions:** Invitee (authenticated).
- **Offline:** Requires connectivity. · **Realtime:** Roster updates for all.
- **Failure:** Expired → request new. · **Success:** Member added.
- **Acceptance Criteria:** Accepted member sees full trip; rejected cannot re-use link.
- **Edge Cases:** Accept after trip deleted/archived; double-accept; account mismatch.

#### REQ-MEM-03 — Remove Member
- **Description:** Owner removes a member.
- **Priority:** P1 · **Dependencies:** REQ-MEM-02.
- **Business Rules:** Owner only; cannot remove members with unsettled balances unless balances reassigned/settled; Owner cannot remove self (must transfer ownership — v1.5).
- **Validation:** Block if member has pending dues.
- **Permissions:** Owner.
- **Offline:** Queued. · **Realtime:** Roster updates.
- **Failure:** Has dues → blocked with explanation.
- **Success:** Member removed; historical expenses retained (attributed).
- **Acceptance Criteria:** Removed member loses access; their past expenses remain in reports.
- **Edge Cases:** Remove member referenced in active splits; remove then re-invite.

### 4.4 Budget

#### REQ-BUD-01 — Budget Tracking
- **Description:** Track total, spent, remaining, and daily spend.
- **Priority:** P0 · **Dependencies:** REQ-TRIP-01, REQ-EXP-01.
- **Business Rules:** Spent = sum of approved (or auto-approved) expenses; Remaining = Total − Spent; Daily = Spent ÷ active trip days.
- **Validation:** Budget ≥0; handle no-budget gracefully (show spent only).
- **Permissions:** Owner & Member (view).
- **Offline:** Computed from local data. · **Realtime:** Live updates on expense changes.
- **Failure:** N/A. · **Success:** Accurate live figures.
- **Acceptance Criteria:** Remaining never silently goes negative without "Over budget" flag.
- **Edge Cases:** No budget set; budget lowered below spent; pending (unapproved) expenses excluded from Spent but shown separately.

### 4.5 Expenses

#### REQ-EXP-01 — Add Expense
- **Description:** Add an expense with amount, category, payer, split, optional receipt/notes.
- **Priority:** P0 · **Dependencies:** REQ-TRIP-01, REQ-MEM-02.
- **Business Rules:** Default split = equal among all members; payer defaults to current user; if Owner-approval enabled, new expense is `pending`.
- **Validation:** Amount required & >0; category required; Paid By required; ≥1 split member; receipt ≤10MB image.
- **Permissions:** Owner & Member.
- **Offline:** Saved locally, queued; UI marks "pending sync".
- **Realtime:** Online members see it instantly.
- **Failure:** Save error → retain draft; receipt upload failure → expense saved, receipt retried.
- **Success:** Loading shown; dashboard updates instantly.
- **Acceptance Criteria:** Amount required · Amount >0 · Category required · Paid By required · Split members required · Works offline · Syncs later · Shows loading · Updates dashboard instantly.
- **Edge Cases:** Duplicate tap (debounce/idempotency) · Invalid amount · Deleted member in split · Offline conflict · Upload failure.

#### REQ-EXP-02 — Edit Expense
- **Description:** Modify an existing expense.
- **Priority:** P0 · **Dependencies:** REQ-EXP-01.
- **Business Rules:** Author may edit own; Owner may edit any; editing approved expense (amount/split) reverts to `pending`.
- **Validation:** Same as add.
- **Permissions:** Owner (any) · Member (own only).
- **Offline:** Queued. · **Realtime:** Broadcast.
- **Failure:** Conflict → §9 (last-write-wins on scalar fields).
- **Success:** Recalculated budget & splits.
- **Acceptance Criteria:** Member cannot edit others'; re-approval triggered on material change.
- **Edge Cases:** Concurrent edits; edit a deleted expense; edit changing split to exclude payer.

#### REQ-EXP-03 — Delete Expense
- **Description:** Soft-delete an expense.
- **Priority:** P0 · **Dependencies:** REQ-EXP-01.
- **Business Rules:** Owner only; soft-delete recoverable 30 days; budget recalculates.
- **Validation:** Confirmation required.
- **Permissions:** Owner.
- **Offline:** Queued. · **Realtime:** Removed for members.
- **Failure:** §9. · **Success:** Removed from totals; restorable.
- **Acceptance Criteria:** Member cannot delete; deleted expense excluded from settlement.
- **Edge Cases:** Delete already-settled expense (blocked/flagged); delete then restore.

#### REQ-EXP-04 — Approve / Reject Expense
- **Description:** Owner approves or rejects pending expenses.
- **Priority:** P1 · **Dependencies:** REQ-EXP-01.
- **Business Rules:** Owner only; only approved expenses count toward Spent and settlement; rejection requires no reason (optional note).
- **Validation:** Expense must be `pending`.
- **Permissions:** Owner.
- **Offline:** Queued. · **Realtime:** Status broadcast; author notified.
- **Failure:** §9. · **Success:** Status `approved`/`rejected`; budget updates.
- **Acceptance Criteria:** Member cannot approve; rejected expense excluded from totals.
- **Edge Cases:** Approve then author edits; approve an expense from a removed member.

#### REQ-EXP-05 — Split Expense
- **Description:** Define which members share an expense (equal split, v1.0).
- **Priority:** P0 · **Dependencies:** REQ-EXP-01.
- **Business Rules:** v1.0 = equal split among selected members; custom/percentage = v1.5.
- **Validation:** ≥1 member; shares sum to total (rounding handled, remainder to payer).
- **Permissions:** Author/Owner.
- **Offline:** Local. · **Realtime:** Reflected in balances.
- **Acceptance Criteria:** Equal split sums exactly to amount including rounding.
- **Edge Cases:** Single-member split; rounding remainder; member removed after split.

#### REQ-EXP-06 — Receipt & Notes
- **Description:** Attach a receipt photo and notes.
- **Priority:** P1 · **Dependencies:** REQ-EXP-01; Storage.
- **Business Rules:** One receipt per expense (v1.0); image only.
- **Validation:** ≤10MB; jpg/png/heic.
- **Permissions:** Author/Owner.
- **Offline:** Photo cached locally, uploaded on sync.
- **Failure:** Upload retry with backoff; expense usable without receipt.
- **Acceptance Criteria:** Expense saves even if upload pending; receipt visible after sync.
- **Edge Cases:** Oversized image; corrupt file; upload interrupted.

### 4.6 Settlement

#### REQ-SET-01 — Settlement Calculation
- **Description:** Compute net balances and minimal "who pays who".
- **Priority:** P0 · **Dependencies:** REQ-EXP-01, REQ-EXP-05.
- **Business Rules:** Uses approved, non-deleted expenses; minimize number of transactions.
- **Validation:** Sum of all debts = sum of all credits (= 0 net).
- **Permissions:** Owner & Member (view).
- **Offline:** Computed locally. · **Realtime:** Recomputed on expense changes.
- **Failure:** N/A. · **Success:** Clear transaction list.
- **Acceptance Criteria:** Balances net to zero; minimal transactions; matches manual calc.
- **Edge Cases:** Single member; everyone paid equally (no transactions); removed-member balances.

#### REQ-SET-02 — Mark Settlement Paid
- **Description:** Track pending/completed payments.
- **Priority:** P0 · **Dependencies:** REQ-SET-01.
- **Business Rules:** Payer or Owner may mark paid; trip "Settled" when all completed.
- **Validation:** Cannot mark paid twice.
- **Permissions:** Owner & involved payer.
- **Offline:** Queued. · **Realtime:** Status broadcast.
- **Failure:** §9. · **Success:** Transaction `completed`.
- **Acceptance Criteria:** Marking paid updates both parties; idempotent.
- **Edge Cases:** New expense added after "Settled" → reopens settlement; double-mark.

### 4.7 Reports

#### REQ-REP-01 — Reports & Export
- **Description:** Category breakdown, pie/bar charts, timeline, PDF export.
- **Priority:** P0 (PDF) · **Dependencies:** REQ-EXP-01.
- **Business Rules:** Reflects approved expenses; respects filters.
- **Validation:** Valid date range; empty-state when no data.
- **Permissions:** Owner & Member.
- **Offline:** Render from cache; PDF generated locally.
- **Realtime:** Updates with new expenses.
- **Failure:** Export failure → retry; partial data flagged.
- **Success:** Shareable PDF.
- **Acceptance Criteria:** Charts match totals; PDF exports offline.
- **Edge Cases:** No expenses; single category; very large trips (pagination).

### 4.8 AI (v1.5)

#### REQ-AI-01 — Expense Auto-Categorization (v1.5)
- **Description:** Suggest category from expense description.
- **Priority:** P1 (v1.5) · **Dependencies:** REQ-EXP-01; OpenRouter.
- **Business Rules:** Suggestion only; user can override; never blocks save.
- **Validation:** Confidence threshold (see §11).
- **Permissions:** Author/Owner.
- **Offline:** Falls back to manual; queued local heuristic (future).
- **Failure:** Timeout → manual category. · **Success:** Pre-filled category.
- **Acceptance Criteria:** Save works without AI; suggestion editable.
- **Edge Cases:** Ambiguous text; non-English; AI down.

> REQ-AI-02 Trip Insights, REQ-AI-03 Budget Analysis, REQ-AI-04 Suggestions — all **v1.5**, detailed in §11.

---

## 5. User Stories

### 5.1 Authentication
**As a** new user **I want** to sign in with Google/Apple/Email/Phone **so that** I can start quickly.
- **AC:** Any method completes sign-in; session persists; FCM registered.
- **Business Rules:** One account per verified identity.
- **Edge Cases:** Existing account on another provider; OTP throttling.

### 5.2 Create Trip
**As a** user **I want** to create a trip with a budget **so that** I can track group spend.
- **AC:** Trip created online/offline; I'm Owner; 4th active trip blocked on free tier.
- **Business Rules:** Free tier = 3 active trips.
- **Edge Cases:** Duplicate tap; offline quota breach on sync.

### 5.3 Invite Members
**As a** Trip Owner **I want** to invite members **so that** everyone can contribute expenses.
- **AC:** Shareable invite generated; expires in 7 days; member appears on accept.
- **Business Rules:** Owner-only; one pending invite per invitee.
- **Edge Cases:** Expired invite; inviting existing member.

### 5.4 Join Trip
**As an** invitee **I want** to accept an invite **so that** I can join the trip.
- **AC:** Accept adds me as Member; reject is terminal; expired prompts re-request.
- **Business Rules:** Must authenticate first.
- **Edge Cases:** Trip deleted before accept; double-accept.

### 5.5 Add Expense
**As a** member **I want** to add an expense offline **so that** I never lose a spend.
- **AC:** Required fields validated; saves offline; syncs later; dashboard updates instantly.
- **Business Rules:** Equal split default; optional approval.
- **Edge Cases:** Duplicate tap; deleted member; upload failure.

### 5.6 Edit / Delete Expense
**As an** Owner **I want** to edit/delete any expense **so that** I can correct mistakes.
- **AC:** Owner edits/deletes any; member edits own; delete is soft & recoverable.
- **Business Rules:** Material edit → re-approval; delete excluded from settlement.
- **Edge Cases:** Concurrent edits; delete settled expense.

### 5.7 Settlement
**As a** member **I want** a clear "who pays who" **so that** we settle without arguments.
- **AC:** Balances net to zero; minimal transactions; mark paid updates both sides.
- **Business Rules:** Approved expenses only; new expense reopens settlement.
- **Edge Cases:** Removed member balances; double-mark paid.

### 5.8 Reports
**As an** Owner **I want** to export a PDF report **so that** I have a record.
- **AC:** Charts match totals; PDF works offline; filters applied.
- **Business Rules:** Approved expenses only.
- **Edge Cases:** Empty trip; very large trip.

### 5.9 Archive Trip
**As an** Owner **I want** to archive a finished trip **so that** my active list stays clean.
- **AC:** Archived = read-only; unarchive restores; doesn't count to free limit.
- **Business Rules:** Owner-only.
- **Edge Cases:** Add expense while archived (blocked); unarchive past limit.

---

## 6. Permission Matrix

Roles: **Owner**, **Member**, **Admin (Reserved — v1.5+, not active in v1.0)**.

| Action | Owner | Member | Admin (Reserved) |
|--------|:-----:|:------:|:----------------:|
| Create trip | ✅ | ✅ | ✅ |
| Edit trip metadata/budget | ✅ | ❌ | ✅ |
| Delete trip | ✅ | ❌ | ✅ |
| Archive / unarchive trip | ✅ | ❌ | ✅ |
| Invite member | ✅ | ❌ | ✅ |
| Remove member | ✅ | ❌ | ✅ |
| Accept/reject own invite | ✅ | ✅ | ✅ |
| Add expense | ✅ | ✅ | ✅ |
| Edit own expense | ✅ | ✅ | ✅ |
| Edit any expense | ✅ | ❌ | ✅ |
| Delete expense | ✅ | ❌ | ✅ |
| Approve/reject expense | ✅ | ❌ | ✅ |
| Attach receipt/notes | ✅ | ✅ (own) | ✅ |
| View budget | ✅ | ✅ | ✅ |
| View/compute settlement | ✅ | ✅ | ✅ |
| Mark settlement paid | ✅ | ✅ (own txn) | ✅ |
| View reports | ✅ | ✅ | ✅ |
| Export PDF | ✅ | ✅ | ✅ |
| Transfer ownership (v1.5) | ✅ | ❌ | ✅ |
| Manage AI settings (v1.5) | ✅ | ❌ | ✅ |

---

## 7. Data Model Requirements

> Business-level fields and validation only. No SQL/schema.

### 7.1 Trip
- id, name (req, 1–60), destination (opt), startDate (opt), endDate (opt, ≥start), currency (req, default locale), totalBudget (opt, ≥0), status (active/archived/deleted), ownerId (req), createdAt, updatedAt, deletedAt (nullable).

### 7.2 Member
- id, tripId (req), userId (req), role (owner/member/admin-reserved), joinedAt, status (active/removed), removedAt (nullable). Unique per (tripId, userId).

### 7.3 Invitation
- id, tripId (req), invitedBy (req), targetEmailOrPhone (opt), inviteCode (req, unique), status (pending/accepted/rejected/expired), expiresAt (req, default +7d), createdAt, acceptedBy (nullable).

### 7.4 Budget (derived/embedded on Trip)
- totalBudget, spent (computed from approved expenses), remaining (= total − spent), dailySpend (= spent ÷ active days), overBudget (bool). Read-mostly; recomputed on expense change.

### 7.5 Expense
- id, tripId (req), paidBy (req userId), amount (req, >0), currency (= trip currency), category (req), description/notes (opt), date (req, default now), status (pending/approved/rejected), splitType (equal in v1.0), createdBy (req), receiptId (nullable), createdAt, updatedAt, deletedAt (nullable).

### 7.6 ExpenseSplit (child of Expense)
- id, expenseId (req), memberId (req), shareAmount (req, ≥0). Sum of shares = expense amount (rounding remainder to payer).

### 7.7 Settlement
- id, tripId (req), fromMemberId (req), toMemberId (req), amount (req, >0), status (pending/completed), markedBy (nullable), completedAt (nullable), createdAt. Recomputed when expenses change.

### 7.8 Receipt
- id, expenseId (req), imageUrl (req post-upload), localPath (offline), uploadStatus (pending/uploaded/failed), sizeBytes (≤10MB), mimeType (jpg/png/heic), createdAt.

### 7.9 Notification
- id, userId (req), tripId (opt), type (enum, see §10), title, body, payload (deep-link target), readStatus (unread/read), createdAt.

### 7.10 SyncQueueItem (offline)
- id, entityType, entityLocalId, operation (create/update/delete), payload, attemptCount, lastAttemptAt, status (queued/syncing/failed/done), createdAt.

---

## 8. Business Rules

1. **Trip deletion:** Soft-delete only; recoverable 30 days; cascades (soft) to members, expenses, settlements. Owner-only.
2. **Owner leaving:** Owner cannot leave/remove self in v1.0; must delete or archive trip. Ownership transfer is v1.5.
3. **Member removal:** Blocked if member has unsettled balances; past expenses retained and attributed to the (removed) member.
4. **Budget updates:** Editable anytime; lowering below spent is allowed but flags "Over budget"; remaining never hidden.
5. **Expense approvals:** Optional per-trip; only approved expenses affect Spent and Settlement; material edit of approved expense reverts to pending.
6. **Settlement calculation:** Uses approved, non-deleted expenses; minimizes transaction count; balances must net to zero.
7. **Invitation expiry:** Default 7 days; expired invites cannot be accepted; one pending invite per invitee per trip.
8. **Archive behaviour:** Archived trips are read-only and excluded from free-tier active count; unarchive restores editability.
9. **Soft delete:** Trips and expenses soft-deleted (deletedAt set); excluded from all calculations and lists.
10. **Restore behaviour:** Soft-deleted items restorable within 30-day window; restore re-includes them in calculations.
11. **Duplicate prevention:** Client debounce + idempotency key on create operations to prevent duplicate-tap records.
12. **Free-tier limit:** Max 3 active (non-archived, non-deleted) trips; 4th blocked with upsell.
13. **Currency:** Single currency per trip in v1.0; no conversion.

---

## 9. Offline-First Behaviour

1. **Offline creation:** Trips, expenses, splits, receipts (cached), and "mark paid" can be created offline with a local ID and queued.
2. **Offline editing:** Edits applied locally and queued; UI shows "pending sync" badge.
3. **Offline deletion:** Soft-delete locally and queued.
4. **Sync queue:** FIFO per entity, dependency-ordered (trip before its expenses; expense before its receipt/splits).
5. **Conflict resolution:**
   - Scalar fields (amount, category, notes, dates): **last-write-wins** by `updatedAt`.
   - Deletes win over concurrent edits (deleted entity stays deleted).
   - Split sets: server merge by member; if total mismatch, recompute equal split and flag for Owner review.
6. **Retry policy:** Exponential backoff (e.g., 2s, 8s, 30s, 2m, capped) with max attempts; after max, mark `failed` and surface a manual "Retry" action.
7. **Merge strategy:** Last-write-wins for scalars; additive merge for independent child records (splits, receipts); idempotency keys prevent duplicates on retry.
8. **Integrity:** Local IDs remapped to server IDs on first successful sync; references updated atomically.

---

## 10. Notifications (Push — FCM)

| Type | Trigger | Recipient | Deep-link |
|------|---------|-----------|-----------|
| `invite_received` | Owner invites a user (direct) | Invitee | Invitation preview |
| `invite_accepted` | Member accepts | Owner | Members tab |
| `member_removed` | Owner removes member | Removed member | Home |
| `expense_added` | New expense added | Other members | Expense detail |
| `expense_pending_approval` | New pending expense | Owner | Approval queue |
| `expense_approved` | Owner approves | Author | Expense detail |
| `expense_rejected` | Owner rejects | Author | Expense detail |
| `budget_exceeded` | Spent > total budget | All members | Budget view |
| `settlement_pending` | Settlement computed/due | Debtor & creditor | Settlement tab |
| `settlement_completed` | Payment marked paid | Counterparty | Settlement tab |
| `trip_archived` | Owner archives | All members | Archived trips |
| `sync_failed` (local) | Sync max-retries reached | Device user | Sync queue |

Rules: respect per-user notification preferences (v1.5); collapse duplicates; do not notify the actor of their own action.

---

## 11. AI Features (v1.5)

| Aspect | Specification |
|--------|---------------|
| **Provider** | OpenRouter (Gemini / Claude / GPT); future local fallback for basic categorization. |
| **Inputs** | Expense description/notes, amount, trip context (categories, prior expenses). |
| **Outputs** | Suggested category (REQ-AI-01); trip insights summary; budget analysis; spend suggestions. |
| **Confidence score** | 0–1; auto-apply suggestion only if ≥0.75, else show as suggestion; below 0.4 → no suggestion. |
| **Fallback** | On low confidence/timeout/error → manual category selection; never blocks expense save. |
| **Prompt behaviour** | Deterministic, constrained to the fixed category list; no free-text categories; PII-minimized payloads. |
| **Latency expectations** | Categorization suggestion target <1.5s p95; insights generated async (non-blocking), target <5s. |
| **Failure handling** | Timeout (≥3s) → silent fallback to manual; log for analytics; no user-facing error for suggestions. |
| **Caching** | Cache identical (normalized description → category) results for 30 days per trip; insights cached until next material expense change. |

AI scope (v1.5): REQ-AI-01 Categorization · REQ-AI-02 Trip Insights · REQ-AI-03 Budget Analysis · REQ-AI-04 Suggestions.

---

## 12. Reports

| Report | Inputs | Filters | Charts | Calculations | Export |
|--------|--------|---------|--------|--------------|--------|
| **Category Breakdown** | Approved expenses | Date range, member, category | Pie | Sum per category; % of total | PDF (v1.0); Excel (v2.0) |
| **Spend by Member** | Approved expenses, splits | Date range, category | Bar | Paid vs owed per member | PDF |
| **Timeline** | Approved expenses | Date range | Line/bar over time | Daily/cumulative spend | PDF |
| **Budget Summary** | Budget, approved expenses | — | Gauge/progress | Total, spent, remaining, daily, over-budget flag | PDF |
| **Settlement Report** | Settlement transactions | Status | List | Who pays who; pending/completed | PDF |

Rules: all reports use approved, non-deleted expenses; empty-state shown when no data; PDF generation works offline from cached data.

---

## 13. Error States

| Error | Trigger | Expected UI Behaviour |
|-------|---------|-----------------------|
| **No Internet** | Network unavailable | Non-blocking banner; offline features remain usable; queued actions show "pending sync". |
| **Unauthorized (401)** | Token expired/revoked | Attempt silent refresh; if fails, route to Auth with "Session expired" message. |
| **Receipt upload failed** | Storage/network error | Expense saved without receipt; "Retry upload" affordance; auto-retry with backoff. |
| **AI timeout** | OpenRouter slow/down (v1.5) | Silent fallback to manual category; no blocking error. |
| **Server unavailable (5xx)** | Backend down | Retry with backoff; show "Can't reach TripMate, will retry"; reads served from cache. |
| **Permission denied (403)** | Role lacks action | Inline toast "You don't have permission"; hide/disable action where known in advance. |
| **Validation failed** | Bad input | Inline field-level errors; block submit; focus first invalid field. |
| **Quota exceeded** | 4th active trip (free) | Upsell sheet for Premium; block creation. |
| **Conflict** | Concurrent edit on sync | Apply resolution (§9); if flagged, show "Reviewed needed" badge to Owner. |
| **Invitation expired** | Accept after expiry | "Invitation expired"; offer "Request new invite". |

---

## 14. Analytics Events

| Event | Key Properties |
|-------|----------------|
| `app_opened` | userId, source |
| `signed_in` | method (google/apple/email/phone) |
| `trip_created` | tripId, hasBudget, isOffline |
| `member_invited` | tripId, channel (link/email/phone) |
| `invite_accepted` | tripId, inviteId |
| `invite_rejected` | tripId, inviteId |
| `expense_added` | tripId, amount, category, hasReceipt, isOffline |
| `expense_edited` | tripId, expenseId, fieldsChanged |
| `expense_deleted` | tripId, expenseId |
| `expense_approved` | tripId, expenseId |
| `expense_rejected` | tripId, expenseId |
| `budget_exceeded` | tripId, overByAmount |
| `settlement_viewed` | tripId, txnCount |
| `settlement_completed` | tripId, txnId, amount |
| `report_viewed` | tripId, reportType |
| `report_exported` | tripId, format (pdf) |
| `trip_archived` | tripId |
| `ai_used` | tripId, feature, confidence, accepted (v1.5) |
| `premium_viewed` | source/trigger |
| `subscription_purchased` | plan, price, currency |
| `sync_completed` | itemsSynced, durationMs |
| `sync_failed` | entityType, attemptCount |

Rules: no PII in event properties (use IDs); events fire client-side; offline events buffered and flushed on reconnect.

---

## 15. Release Scope

> Single source of truth. No feature appears in two releases.

### 15.1 MVP — v1.0
- Authentication: Google, Apple (iOS), Email, Phone OTP, session/logout.
- Trips: create, edit, delete (soft), archive/unarchive.
- Members: invite (link/code/email/phone), accept/reject, remove.
- Budget: total/spent/remaining/daily, over-budget flag.
- Expenses: add, edit, delete, approve/reject, **equal split**, receipt photo, notes.
- Settlement: who-pays-who, pending/completed, mark paid.
- Reports: category breakdown, pie/bar/timeline, **PDF export**.
- Offline-first: queue, sync, conflict resolution (§9).
- Notifications: core set (§10).
- Monetization: free tier (3 active trips, basic reports) + Premium gate (unlimited trips, PDF export beyond basic) — paywall surfaces present.
- **Categorization is manual in v1.0.**

### 15.2 v1.5
- **AI:** auto-categorization, trip insights, budget analysis, suggestions (§11).
- Push notification preferences.
- Enhanced offline sync (smarter merge, conflict review UI).
- Custom/percentage expense splits.
- Ownership transfer; Admin role activation.

### 15.3 v2.0
- Receipt OCR.
- Voice expense entry.
- QR settlement / UPI payments.
- Premium expansion: Excel export, premium themes, priority support.

### 15.4 v3.0 / Future Backlog
- Web app · iOS feature parity · Travel planner · Analytics dashboard.
- Packing list · Currency converter (multi-currency) · Business trips · Family trips · Expense forecast.

---

*This implementation-ready PRD supersedes PRD v1.0. Engineering should treat each REQ-ID as a discrete, testable unit of work.*
