# TripMate — UI/UX Specification

**Version:** 1.0
**Status:** Ready for Design & Engineering
**Last Updated:** 2026-06-26
**Design System:** Material 3 (Material You)
**Companion Docs:** Product Vision v1.0, PRD v2.0, Technical Architecture v1.0
**Scope:** Screen-level UX contracts. No Flutter code.

---

## 1. Design Foundations

### 1.1 Material 3 System
- **Color:** dynamic color (Material You) with a brand seed (travel teal/indigo); full tonal palette; light + dark themes. Semantic roles: `primary` (CTAs), `secondary` (chips/filters), `tertiary` (accents), `error` (destructive/validation), `surface`/`surfaceContainer` tiers for elevation.
- **Typography:** M3 type scale (Display → Label). Money uses tabular/lining figures for alignment.
- **Shape:** rounded corners — cards `medium` (12dp), sheets/dialogs `large` (28dp), FAB/chips `full`.
- **Elevation:** tonal elevation (surface tints) over shadows; FAB elevated; bottom sheets at level 1–3.
- **Motion:** M3 emphasized easing; container transforms for list→detail; shared-axis for tab/step transitions; <300ms perceived (Architecture §16).
- **Spacing:** 4dp grid; screen padding 16dp; list item min height 56dp; touch target ≥48×48dp.

### 1.2 Global Patterns
- **Navigation shell:** `NavigationBar` (bottom) with 3–4 destinations inside a trip; top-level **Trips** list outside the shell.
- **Primary action:** `FloatingActionButton` (extended on primary screens).
- **Transient feedback:** `SnackBar` for confirmations/undo; `Banner` for persistent states (offline, over-budget).
- **Inputs:** filled `TextField`s; `SegmentedButton` for split type; `Chip`s for category/filters.
- **Destructive actions:** confirmation `Dialog` with explicit verb ("Delete", "Archive").
- **Currency display:** symbol + grouped digits per trip currency; never raw floats.

### 1.3 Global States (apply to every screen)
- **Offline:** top `MaterialBanner` "You're offline — changes will sync later." Sync-pending items show an inline cloud-off badge. Writes remain enabled.
- **Loading:** skeleton loaders for lists/cards; `CircularProgressIndicator` only for blocking actions; buttons show inline spinner + disabled state.
- **Error:** inline error region with icon + message + Retry; never a dead end.
- **Empty:** illustration + one-line explanation + primary CTA.

### 1.4 Accessibility Baseline (all screens)
- Contrast ≥ 4.5:1 text / 3:1 large text & icons; never color-only signaling (pair with icon/label).
- All interactive elements labeled for screen readers (TalkBack/VoiceOver); semantic headings per screen.
- Dynamic type up to 200%; layouts reflow, no truncation of critical data.
- Focus order logical; visible focus indicators; gesture actions have button equivalents.
- Min target 48dp; haptics on key confirmations; respects reduced-motion setting.

---

## 2. Screen Inventory

| # | Screen | Shell | Roles |
|---|--------|-------|-------|
| 1 | Splash | — | all |
| 2 | Sign In | — | unauth |
| 3 | OTP Verify | — | unauth |
| 4 | Profile Setup (onboarding) | — | new user |
| 5 | Trips (Home) | top-level | all |
| 6 | Create / Edit Trip | — | owner |
| 7 | Trip Dashboard (Budget) | shell tab | member |
| 8 | Expenses List | shell tab | member |
| 9 | Add / Edit Expense | — | member |
| 10 | Expense Detail | — | member |
| 11 | Approval Queue | — | owner |
| 12 | Members & Invite | — | owner/member |
| 13 | Join Trip (Invite Accept) | — | invitee |
| 14 | Settlement | shell tab | member |
| 15 | Reports | shell tab | member |
| 16 | Notifications | — | all |
| 17 | Archived Trips | — | all |
| 18 | Settings / Profile | — | all |
| 19 | Paywall / Premium | — | all |
| 20 | AI Insights (v1.5) | — | member |

---

## 3. Screen Specifications

> Each screen lists: Purpose · Components · User Actions · Empty · Loading · Error · Offline · Navigation · Validation · Accessibility.

### 3.1 Splash
- **Purpose:** Brand moment while bootstrapping (restore session, open DB, route).
- **Components:** centered logo + wordmark; subtle indeterminate progress.
- **User Actions:** none (auto-routes).
- **Empty:** n/a.
- **Loading:** the screen *is* the loading state; ≤1.5s target, then route.
- **Error:** if bootstrap fails (DB open) → full-screen error with Retry/Restart.
- **Offline:** proceeds; restores cached session and routes to Home.
- **Navigation:** → Sign In (unauth) or Trips (auth) or Profile Setup (auth, no profile).
- **Validation:** n/a.
- **Accessibility:** announce "TripMate, loading"; respects reduced motion (static logo).

### 3.2 Sign In
- **Purpose:** Authenticate via Google, Apple (iOS), Email, Phone.
- **Components:** logo; provider buttons (Google, Apple); email + password fields; "Continue with phone" link; primary "Sign in"; "Create account" toggle; legal links.
- **User Actions:** tap provider; enter email/password; switch to phone; sign-up.
- **Empty:** n/a (form).
- **Loading:** button inline spinner; providers disabled during request.
- **Error:** inline under field — `AUTH_INVALID_CREDENTIALS` ("Email or password is incorrect"), `AUTH_EMAIL_TAKEN`; network → banner "No internet, sign-in needs a connection."
- **Offline:** social/email sign-in disabled with helper text; previously signed-in users skip this screen entirely.
- **Navigation:** → OTP (phone), → Profile Setup (first time), → Trips. Deep-link intent preserved post-auth.
- **Validation:** email RFC format; password ≥8 chars; submit disabled until valid; show password toggle.
- **Accessibility:** fields labeled + error text linked via `aria`-equivalent; provider buttons describe action; password toggle announced.

### 3.3 OTP Verify
- **Purpose:** Verify phone via 6-digit code.
- **Components:** phone number (masked) display; 6-cell OTP input; resend timer; "Verify" button; "Change number" link.
- **User Actions:** enter code (auto-advance, paste support); resend; edit number.
- **Empty:** n/a.
- **Loading:** verify button spinner; auto-submit on 6th digit.
- **Error:** `AUTH_OTP_INVALID` ("Incorrect code"), `AUTH_OTP_THROTTLED` ("Too many tries, wait 15 min") with disabled resend + countdown.
- **Offline:** blocked with banner; cannot verify offline.
- **Navigation:** ← back to Sign In; → Profile Setup/Trips on success.
- **Validation:** 6 numeric digits; resend throttled (5/15min); 5-min code TTL countdown shown.
- **Accessibility:** OTP cells announce position ("digit 3 of 6"); resend timer announced politely; numeric keyboard.

### 3.4 Profile Setup (Onboarding)
- **Purpose:** Capture display name (+ optional avatar) for new users.
- **Components:** avatar picker (optional); display name field; "Get started" CTA; skip-avatar.
- **User Actions:** pick/take photo; enter name; continue.
- **Empty:** n/a.
- **Loading:** CTA spinner while upserting profile.
- **Error:** validation inline; upload failure non-blocking (proceed without avatar, retry later).
- **Offline:** allowed; profile queued, avatar upload deferred.
- **Navigation:** → Trips (Home).
- **Validation:** name required, 1–60 chars; image ≤10MB.
- **Accessibility:** avatar picker labeled; name field required state announced.

### 3.5 Trips (Home)
- **Purpose:** List active trips; entry to create/join/archive.
- **Components:** top app bar (title, overflow → Archived/Settings, notifications icon w/ badge); trip cards (name, destination, date range, member avatars, spent/budget progress bar, status chip); extended FAB "New Trip"; pull-to-refresh.
- **User Actions:** tap trip → Dashboard; long-press → quick actions (archive/leave); FAB → Create Trip; tap notifications; menu → Join via code.
- **Empty:** illustration + "No trips yet — create your first trip" + "New Trip" CTA + secondary "Join with a code".
- **Loading:** 3–4 card skeletons.
- **Error:** inline error card + Retry; cached list still shown if available.
- **Offline:** banner; cached trips fully usable; create works (queued, pending badge on new card).
- **Navigation:** → Dashboard, Create Trip, Join Trip, Notifications, Settings, Archived.
- **Validation:** free-tier limit — 4th active trip → paywall sheet instead of create.
- **Accessibility:** each card a labeled button summarizing name, spend, members count; progress bar has text alt ("₹12,000 of ₹50,000 spent").

### 3.6 Create / Edit Trip
- **Purpose:** Create or edit trip metadata + budget.
- **Components:** name field; destination field; date range picker; currency selector; total budget field; "Create"/"Save"; (edit) "Archive"/"Delete" in overflow.
- **User Actions:** fill fields; pick dates; choose currency; submit; (edit) archive/delete.
- **Empty:** n/a (form).
- **Loading:** submit spinner; fields disabled.
- **Error:** validation inline; `QUOTA_TRIP_LIMIT` → paywall; conflict on edit → "Trip changed elsewhere, reloaded."
- **Offline:** create/edit queued; success toast "Saved — will sync."
- **Navigation:** → "Invite members?" prompt after create → Members; ← cancel with unsaved-changes guard.
- **Validation:** name required 1–60; end ≥ start; budget ≥0 (optional); currency required; lowering budget below spent allowed with "Over budget" warning.
- **Accessibility:** date picker keyboard-navigable; currency selector searchable + labeled; destructive items in overflow clearly labeled.

### 3.7 Trip Dashboard (Budget)
- **Purpose:** At-a-glance trip finances and quick add.
- **Components:** budget header card (Total / Spent / Remaining / Daily), over-budget flag; mini category breakdown; recent expenses preview (last 3–5); member avatars; NavigationBar (Dashboard, Expenses, Settlement, Reports); extended FAB "Add Expense".
- **User Actions:** add expense; tap expense → detail; tap "See all" → Expenses; switch tabs; owner → approval badge entry.
- **Empty:** budget shows ₹0 spent; "No expenses yet — add your first" CTA.
- **Loading:** header + list skeletons; figures animate in.
- **Error:** per-section inline error + Retry; cached figures shown.
- **Offline:** banner; figures computed locally; add works.
- **Navigation:** ↔ shell tabs; → Add Expense, Expense Detail, Approval Queue, Members (avatars).
- **Validation:** n/a (read).
- **Accessibility:** budget figures grouped with labels ("Remaining: ₹38,000"); over-budget conveyed by icon + text, not color alone; progress has text equivalent.

### 3.8 Expenses List
- **Purpose:** Full chronological/filtered expense ledger.
- **Components:** filter bar (date range, member, category chips, status); grouped list by date; each row: category icon, description, payer, amount, status badge (pending/approved), pending-sync badge, receipt thumbnail; FAB "Add Expense".
- **User Actions:** filter; tap row → detail; swipe (owner) → approve/delete; add.
- **Empty:** "No expenses match" (filtered) or first-run empty with CTA.
- **Loading:** list skeletons.
- **Error:** inline + Retry; cached list shown.
- **Offline:** banner; new/edited items show pending badge; filters work on local data.
- **Navigation:** → Expense Detail, Add Expense.
- **Validation:** filter ranges valid (from ≤ to).
- **Accessibility:** each row labeled "Fuel, ₹1,200, paid by Rahul, pending"; swipe actions have menu equivalent; filter chips announce selected state.

### 3.9 Add / Edit Expense
- **Purpose:** Create or edit an expense with split.
- **Components:** amount field (large, numeric, currency-prefixed); category chips/grid; "Paid by" selector (default = me); split section — `SegmentedButton` (Equal / Custom* / %*) + member checklist with per-member shares; date picker; receipt attach (camera/gallery, thumbnail + remove); notes field; "Save".
- **User Actions:** enter amount; pick category (AI suggestion chip in v1.5); choose payer; select split members; attach receipt; save.
- **Empty:** members default all-selected, equal split prefilled.
- **Loading:** save spinner; receipt shows upload progress (non-blocking).
- **Error:** field validation inline; `EXPENSE_SPLIT_MISMATCH` ("Splits must total ₹X"); receipt upload failure → "Saved, receipt will upload later".
- **Offline:** full create/edit; receipt cached; pending badge; "Saved — syncs later".
- **Navigation:** ← cancel with unsaved guard; → back to list/detail; budget updates instantly.
- **Validation:** amount required & >0; category required; payer required; ≥1 split member; Σ shares = amount (remainder to payer); receipt ≤10MB image; **duplicate-tap debounced**.
- **Accessibility:** amount field announces currency; category grid items labeled; split totals read aloud on change; per-member share inputs labeled with member name.

### 3.10 Expense Detail
- **Purpose:** View one expense and its split/receipt; act on it.
- **Components:** header (amount, category, date, status); payer; split breakdown list (member → share); receipt viewer (tap → full-screen, signed URL); notes; actions — Edit (author/owner), Delete (owner), Approve/Reject (owner, if pending).
- **User Actions:** view receipt; edit; delete; approve/reject.
- **Empty:** n/a (single entity).
- **Loading:** detail skeleton; receipt lazy-loads with placeholder.
- **Error:** receipt load failure → retry thumbnail; action errors via snackbar.
- **Offline:** view from cache; receipt may be unavailable if not yet cached ("Receipt will load when online"); actions queue.
- **Navigation:** ← back; → Edit Expense.
- **Validation:** approve/reject only when pending; delete confirmation dialog.
- **Accessibility:** split list labeled per member; receipt image has alt; approve/reject buttons describe consequence.

### 3.11 Approval Queue (Owner)
- **Purpose:** Review and approve/reject pending expenses.
- **Components:** list of pending expenses (payer, amount, category, date); per-item Approve / Reject; optional bulk approve; reject reason sheet (optional).
- **User Actions:** approve; reject (+optional note); open detail.
- **Empty:** "All caught up — no pending expenses" illustration.
- **Loading:** list skeleton.
- **Error:** action error snackbar + retry; `EXPENSE_STATUS_INVALID` if changed elsewhere → item refreshed.
- **Offline:** actions queue; items show pending-sync badge.
- **Navigation:** entered from Dashboard badge; → Expense Detail.
- **Validation:** only pending items actionable.
- **Accessibility:** each item announces amount + payer; approve/reject clearly labeled; bulk action confirms count.

### 3.12 Members & Invite
- **Purpose:** View roster; invite/remove members.
- **Components:** member list (avatar, name, role chip — Owner/Member, dues indicator); "Invite" button → invite sheet (share link/code, or email/phone field, copy/share actions, expiry note); per-member overflow (owner: remove).
- **User Actions:** invite (share link); copy code; remove member; view member.
- **Empty:** only owner present → "Invite friends to start splitting" CTA.
- **Loading:** roster skeleton; invite generation spinner in sheet.
- **Error:** `INVITE_DUPLICATE` ("Already invited"), `MEMBER_HAS_DUES` ("Settle their balance first"), `TRIP_ARCHIVED`.
- **Offline:** roster cached; invite generation requires connection → "Connect to create an invite" (queued delivery for direct invites).
- **Navigation:** ← back to Dashboard.
- **Validation:** email/phone format for direct invite; owner-only remove; 7-day expiry shown.
- **Accessibility:** roster items labeled with role; invite sheet share targets labeled; remove confirms with member name.

### 3.13 Join Trip (Invite Accept)
- **Purpose:** Preview and accept/reject an invitation from a deep link/code.
- **Components:** trip preview card (name, owner, member count, dates); "Accept" / "Reject"; (if unauth) sign-in prompt first.
- **User Actions:** accept; reject; sign in then resume.
- **Empty:** n/a.
- **Loading:** preview skeleton; accept spinner.
- **Error:** `INVITE_EXPIRED` ("This invite has expired") + "Ask for a new one"; `INVITE_INVALID`; already a member → route into trip.
- **Offline:** accept requires connection → banner "Connect to join this trip."
- **Navigation:** unauth → Sign In (intent preserved) → back here; accept → Trip Dashboard; reject → Home.
- **Validation:** invite must be pending + unexpired.
- **Accessibility:** preview summarized aloud; accept/reject prominent and labeled; expired state clearly announced.

### 3.14 Settlement
- **Purpose:** Show net balances and "who pays who"; track payments.
- **Components:** summary (your net: you owe / you're owed); "who pays who" transaction list (from → to, amount, status); per-transaction "Mark paid"; settled state banner; recompute on changes.
- **User Actions:** mark paid; view member; (implicit) recompute.
- **Empty:** "Nothing to settle yet" (no expenses) or "All settled 🎉" (all completed).
- **Loading:** balance + list skeleton.
- **Error:** compute error inline + Retry; `CONFLICT_VERSION` on mark-paid → refresh.
- **Offline:** computed locally; mark-paid queued (pending badge).
- **Navigation:** shell tab; → Member detail.
- **Validation:** mark-paid only on pending; idempotent; permission (owner or debtor).
- **Accessibility:** each transaction announced "Amit pays Prem ₹500, pending"; net summary labeled; settled state conveyed by text + icon.

### 3.15 Reports
- **Purpose:** Visual breakdowns + PDF export.
- **Components:** filter bar (date range, member, category); chart switcher (Pie — category, Bar — by member, Timeline); totals summary; "Export PDF" button.
- **User Actions:** change filters; switch chart; export/share PDF.
- **Empty:** "No data for this range — add expenses or change filters."
- **Loading:** chart skeleton/shimmer; export spinner.
- **Error:** chart render error + Retry; export failure → retry.
- **Offline:** renders from cache; PDF generated locally (works offline).
- **Navigation:** shell tab; share sheet for export.
- **Validation:** valid date range; empty-state when no approved expenses.
- **Accessibility:** **charts require non-visual equivalents** — accompanying data table / readable summary ("Food 40%, Fuel 25%…"); legend labeled; export button describes output.

### 3.16 Notifications
- **Purpose:** History of push notifications + deep-link entry.
- **Components:** list grouped by date; each item: type icon, title, body, timestamp, unread dot; tap → deep-link target; "Mark all read".
- **User Actions:** tap → navigate; mark read; mark all read.
- **Empty:** "No notifications yet."
- **Loading:** list skeleton.
- **Error:** inline + Retry; cached list shown.
- **Offline:** cached list; deep-links to cached content work; remote-only targets show "Connect to view."
- **Navigation:** → relevant screen per type (invite, expense, settlement, etc.).
- **Validation:** n/a.
- **Accessibility:** unread state announced (not dot-only); each item labeled with type + time.

### 3.17 Archived Trips
- **Purpose:** Browse read-only archived trips; restore.
- **Components:** list of archived trips (greyed, "Archived" chip); tap → read-only Dashboard; overflow → Unarchive.
- **User Actions:** open (read-only); unarchive (owner).
- **Empty:** "No archived trips."
- **Loading:** card skeletons.
- **Error:** inline + Retry.
- **Offline:** cached; unarchive queued; unarchive past free limit → paywall.
- **Navigation:** from Home overflow; → read-only Dashboard.
- **Validation:** owner-only unarchive; archived screens block writes (CTAs hidden/disabled with tooltip "Archived — read only").
- **Accessibility:** archived/read-only state announced on entry; disabled actions explain why.

### 3.18 Settings / Profile
- **Purpose:** Manage account, preferences, subscription, sign-out.
- **Components:** profile header (avatar, name, email — edit); sections: Account, Notifications (prefs — v1.5), Appearance (theme: system/light/dark), Subscription (tier + "Go Premium"), About/Legal, Sign out; "Delete account" (destructive).
- **User Actions:** edit profile; toggle theme; manage subscription; sign out; delete account.
- **Empty:** n/a.
- **Loading:** inline spinners per action.
- **Error:** action snackbars; sign-out with unsynced data → warning dialog.
- **Offline:** profile/theme editable (queued); subscription/delete require connection.
- **Navigation:** → Paywall; → Sign In after sign-out.
- **Validation:** name 1–60; delete-account double confirm (typed/explicit).
- **Accessibility:** toggles labeled with state; destructive items distinct + confirmed; theme change announced.

### 3.19 Paywall / Premium
- **Purpose:** Communicate Premium value; start purchase.
- **Components:** plan card(s); feature comparison (Free vs Premium — unlimited trips, AI, OCR, voice, exports, themes, priority support); price; "Upgrade" CTA; restore purchases; legal.
- **User Actions:** select plan; purchase; restore; dismiss.
- **Empty:** n/a.
- **Loading:** purchase flow spinner; store sheet.
- **Error:** purchase failed/cancelled → non-blocking message; restore errors.
- **Offline:** purchase disabled with "Connect to upgrade."
- **Navigation:** entered from quota limit, Settings, AI gates; ← dismiss returns to origin.
- **Validation:** store handles payment; reflect entitlement post-purchase.
- **Accessibility:** comparison table readable (not image-only); price + terms announced; CTA describes recurring nature.

### 3.20 AI Insights (v1.5)
- **Purpose:** Show AI trip insights, budget analysis, suggestions.
- **Components:** insight cards (spend summary, budget pace, suggestions); "Regenerate"; confidence/freshness note; gated behind Premium.
- **User Actions:** read; regenerate; act on suggestion (e.g., jump to a category).
- **Empty:** "Add a few expenses to unlock insights."
- **Loading:** generating shimmer ("Analyzing your trip…", async, non-blocking).
- **Error:** `AI_TIMEOUT`/error → "Couldn't generate insights — try again"; **never blocks** other screens.
- **Offline:** shows last cached insights with "Updated when online"; regenerate disabled.
- **Navigation:** from Dashboard/Reports entry; Premium gate → Paywall.
- **Validation:** Premium entitlement; rate-limited (graceful message).
- **Accessibility:** insight text fully readable (charts have text equivalents); regenerate labeled; freshness stated in text.

---

## 4. Cross-Screen UX Rules

### 4.1 Navigation Map
```
Splash → Sign In → (OTP) → Profile Setup → Trips
Trips → Create Trip → Members(Invite)
Trips → Trip Dashboard ⇄ [Expenses | Settlement | Reports]  (NavigationBar)
Dashboard → Add/Edit Expense → Expense Detail
Dashboard → Approval Queue (owner)
Trips → Notifications / Archived / Settings → Paywall
Deep link → Join Trip → (Sign In) → Dashboard
```

### 4.2 State Priority (when multiple apply)
Blocking error > Offline banner > Loading > Empty > Content. Offline never suppresses content (cache-first).

### 4.3 Feedback & Undo
- Destructive actions (delete expense/trip) → SnackBar with **Undo** (soft-delete window) where reversible.
- Optimistic UI: local change shown immediately; pending-sync badge until confirmed; silent reconcile on sync.

### 4.4 Two-Tap Rule (PRD §5)
Common actions reachable in ≤2 taps: Add Expense (FAB), Mark Paid (Settlement row), Approve (queue/swipe), Invite (Members). Validate every flow against this.

### 4.5 Responsive / Adaptive
- Phone-first portrait. Large screens/tablets: master-detail (trip list + dashboard); `NavigationRail` replaces bottom bar ≥ expanded width. Charts scale; forms max-width centered.

---

## 5. Accessibility Specification (Consolidated)

| Area | Requirement |
|------|-------------|
| Contrast | ≥4.5:1 text, ≥3:1 large text/icons/UI |
| Targets | ≥48×48dp; spacing ≥8dp between targets |
| Screen readers | Every control labeled; screens have heading structure; live regions for sync/validation |
| Dynamic type | Support up to 200%; reflow, no clipping of money/labels |
| Color independence | Status (pending/approved/over-budget/unread) uses icon+text, not color alone |
| Motion | Honor reduced-motion; no essential info conveyed only by animation |
| Charts | Always paired with a text/table equivalent (Reports, AI) |
| Forms | Errors announced + linked to field; required state exposed; correct keyboard types |
| Focus | Logical order; visible focus; dialogs trap focus and restore on close |
| Offline/async | Status announced politely, not interrupting input |

---

## 6. Component Inventory (Material 3)

| Pattern | M3 Component |
|---------|--------------|
| Primary action | FAB / Extended FAB |
| Destinations | NavigationBar (phone), NavigationRail (large) |
| Trip/expense cards | Filled/Elevated Card |
| Category/filters | Filter/Assist/Input Chip |
| Split type | SegmentedButton |
| Inputs | Filled TextField + supporting/error text |
| Pickers | DatePicker (range), Dropdown/SearchAnchor (currency) |
| Invite/options | Modal Bottom Sheet |
| Confirmations | AlertDialog |
| Transient feedback | SnackBar (+ Undo) |
| Persistent status | MaterialBanner (offline/over-budget) |
| Charts | Pie / Bar / Line (Reports) + data table |
| Progress | LinearProgressIndicator (budget), Circular (blocking) |
| Lists | ListTile, grouped headers, skeletons |
| Badges | Notification badge, pending-sync, status chips |

---

*This specification defines TripMate's screens and interaction contracts in Material 3. It pairs with the PRD (what) and Technical Architecture (how). UX changes are versioned here and reviewed before build.*
