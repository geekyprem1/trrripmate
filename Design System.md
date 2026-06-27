# TripMate — Design System

**Version:** 1.0
**Status:** Ready for Design & Engineering
**Last Updated:** 2026-06-26
**Foundation:** Material 3 (Material You)
**Companion Docs:** UI/UX Specification v1.0, PRD v2.0
**Scope:** Concrete, tokenized design values. Source of truth for the theme.

---

## 1. Design Principles

1. **Travel-first clarity** — money and budget are the heroes; everything else recedes.
2. **2-tap simplicity** — visual hierarchy guides to the primary action on every screen.
3. **Calm, confident** — generous spacing, soft elevation, restrained color until it matters.
4. **Accessible by construction** — tokens chosen to pass WCAG AA in both themes.
5. **Tokens over hardcoding** — never use raw hex/sizes in UI; consume named tokens only.

---

## 2. Color System

### 2.1 Brand Seed
- **Seed color:** `#0E7C7B` (TripMate Teal). Material You generates tonal palettes from this seed; dynamic color (user wallpaper) may override on Android 12+, with the seed as fallback.

### 2.2 Tonal Palettes (key tones)
| Palette | 10 | 40 | 80 | 90 | 100 |
|---------|----|----|----|----|-----|
| Primary (teal) | `#00201F` | `#0E7C7B` | `#4FD8D5` | `#9FF3F0` | `#FFFFFF` |
| Secondary (indigo) | `#141B2C` | `#4A5B8C` | `#B4C2F0` | `#DCE4FF` | `#FFFFFF` |
| Tertiary (amber accent) | `#2B1700` | `#9A5B00` | `#FFB868` | `#FFDDB8` | `#FFFFFF` |
| Error (red) | `#410002` | `#BA1A1A` | `#FFB4AB` | `#FFDAD6` | `#FFFFFF` |
| Neutral | `#1A1C1C` | `#5E5E5E` | `#C7C7C7` | `#E3E3E3` | `#FFFFFF` |

### 2.3 Light Theme Roles
| Role | Value | Use |
|------|-------|-----|
| `primary` | `#0E7C7B` | CTAs, FAB, active states |
| `onPrimary` | `#FFFFFF` | text/icon on primary |
| `primaryContainer` | `#9FF3F0` | tonal buttons, selected chips |
| `onPrimaryContainer` | `#00201F` | text on primaryContainer |
| `secondary` | `#4A5B8C` | secondary accents |
| `secondaryContainer` | `#DCE4FF` | filter chips, badges |
| `tertiary` | `#9A5B00` | highlights, AI accents |
| `error` | `#BA1A1A` | errors, destructive |
| `errorContainer` | `#FFDAD6` | error surfaces |
| `surface` | `#FAFDFC` | base background |
| `surfaceContainerLow` | `#F2F5F4` | cards (low) |
| `surfaceContainer` | `#ECEFEE` | cards, sheets |
| `surfaceContainerHigh` | `#E6E9E8` | elevated sheets/menus |
| `onSurface` | `#191C1C` | primary text |
| `onSurfaceVariant` | `#3F4948` | secondary text, icons |
| `outline` | `#6F7978` | borders, dividers |
| `outlineVariant` | `#BEC9C7` | subtle dividers |
| `inverseSurface` | `#2D3130` | snackbars |
| `inverseOnSurface` | `#EFF1F0` | snackbar text |

### 2.4 Semantic / Financial Colors
> Status is **never color-only** — always paired with icon + label (Accessibility §15).

| Token | Light | Dark | Meaning |
|-------|-------|------|---------|
| `success` | `#1E6E3A` | `#7BDB9B` | settled / approved / under budget |
| `onSuccessContainer` | `#00210E` | `#00210E` | text |
| `successContainer` | `#A6F2C0` | `#003919` | success surface |
| `warning` | `#9A5B00` | `#FFB868` | nearing budget / pending |
| `warningContainer` | `#FFDDB8` | `#3A2600` | warning surface |
| `danger` (= error) | `#BA1A1A` | `#FFB4AB` | over budget / rejected |
| `info` | `#4A5B8C` | `#B4C2F0` | neutral info |
| `money.positive` | `#1E6E3A` | `#7BDB9B` | you're owed / credit |
| `money.negative` | `#BA1A1A` | `#FFB4AB` | you owe / debit |
| `money.neutral` | `#3F4948` | `#BEC9C7` | settled zero |

### 2.5 Contrast Rules
- Body text on surface ≥ 4.5:1; large text/icons ≥ 3:1.
- All container/onContainer pairs are pre-validated AA. Never place `onSurfaceVariant` text on `primary`.

---

## 3. Typography

**Type family:** primary `Inter` (or platform default: Roboto/SF); **numeric/money** uses tabular figures (`font-feature-settings: "tnum"`). Optional display face for brand: `Plus Jakarta Sans` (logo only).

### 3.1 Type Scale (M3)
| Token | Size / Line | Weight | Use |
|-------|-------------|--------|-----|
| `displayLarge` | 57 / 64 | 400 | rare, splash |
| `displaySmall` | 36 / 44 | 400 | big budget figure |
| `headlineMedium` | 28 / 36 | 600 | screen titles |
| `headlineSmall` | 24 / 32 | 600 | section headers |
| `titleLarge` | 22 / 28 | 600 | app bar title |
| `titleMedium` | 16 / 24 | 600 | card titles, list primary |
| `titleSmall` | 14 / 20 | 600 | dense titles |
| `bodyLarge` | 16 / 24 | 400 | primary body |
| `bodyMedium` | 14 / 20 | 400 | secondary body |
| `bodySmall` | 12 / 16 | 400 | captions, timestamps |
| `labelLarge` | 14 / 20 | 600 | buttons |
| `labelMedium` | 12 / 16 | 600 | chips, tabs |
| `labelSmall` | 11 / 16 | 600 | badges, overlines |

### 3.2 Money Typography
| Context | Token | Notes |
|---------|-------|-------|
| Hero budget (Dashboard) | `displaySmall`, tabular | symbol smaller, grouped digits |
| Expense amount (row) | `titleMedium`, tabular | right-aligned |
| Split shares | `bodyMedium`, tabular | — |
| Settlement amounts | `titleMedium`, tabular + money color | — |

### 3.3 Rules
- Max 2 type sizes per card. Titles use weight 600, body 400.
- Dynamic type scales all tokens proportionally up to 200%.
- Never letter-spacing on body; labels use M3 default tracking.

---

## 4. Spacing & Layout

### 4.1 Spacing Scale (4dp base)
| Token | dp | Use |
|-------|----|----|
| `space.0` | 0 | — |
| `space.1` | 4 | icon-text gap, dense |
| `space.2` | 8 | intra-component |
| `space.3` | 12 | list item vertical |
| `space.4` | 16 | **screen padding**, card padding |
| `space.5` | 24 | section spacing |
| `space.6` | 32 | major section breaks |
| `space.8` | 48 | empty-state spacing |
| `space.10` | 64 | hero spacing |

### 4.2 Layout Rules
- **Screen edge padding:** 16dp (phone), 24dp (tablet).
- **Card padding:** 16dp; **card gap:** 12dp.
- **List item:** min height 56dp; leading icon 40dp avatar / 24dp icon; 16dp horizontal padding.
- **Section gap:** 24dp; **header → content:** 8dp.
- **Touch target:** ≥48×48dp; min gap between targets 8dp.
- **Max content width** (large screens): 640dp, centered.

### 4.3 Grid
- 4dp baseline grid for all spacing/sizing.
- Columns: phone = 4, tablet = 8, with 16/24dp gutters.

---

## 5. Shape & Corner Radius

| Token | Radius | Applied to |
|-------|--------|-----------|
| `shape.none` | 0 | full-bleed media |
| `shape.xs` | 4 | chips inner, badges |
| `shape.sm` | 8 | text fields, small buttons |
| `shape.md` | 12 | **cards**, list containers |
| `shape.lg` | 16 | large cards, banners |
| `shape.xl` | 28 | **bottom sheets, dialogs** |
| `shape.full` | 999 | FAB, chips, avatars, pills |

---

## 6. Elevation

Material 3 **tonal elevation** (surface tint) preferred over shadows; shadow only where separation is essential (FAB, menus).

| Level | dp | Surface token | Shadow | Use |
|-------|----|--------------|--------|-----|
| 0 | 0 | `surface` | none | base background |
| 1 | 1 | `surfaceContainerLow` | subtle | cards at rest |
| 2 | 3 | `surfaceContainer` | soft | raised cards, top app bar (scrolled) |
| 3 | 6 | `surfaceContainerHigh` | medium | FAB, bottom sheets, menus |
| 4 | 8 | `surfaceContainerHigh` | medium+ | dialogs |
| 5 | 12 | `surfaceContainerHighest` | strong | rare, modal peaks |

**Rules:** elevation conveys hierarchy, not decoration; do not stack >2 elevation levels in one view; dark mode reduces shadow, increases tint.

---

## 7. Buttons

| Type | Token | Use | Anatomy |
|------|-------|-----|---------|
| **Filled** | `button.filled` | primary CTA (Save, Create) | `primary` bg, `onPrimary` label, `shape.full`, height 40dp, label `labelLarge` |
| **Filled tonal** | `button.tonal` | secondary primary (Invite) | `primaryContainer` bg, `onPrimaryContainer` label |
| **Outlined** | `button.outlined` | secondary (Cancel) | `outline` border, `primary` label |
| **Text** | `button.text` | low emphasis (links) | `primary` label, no container |
| **Elevated** | `button.elevated` | on busy/media surfaces | level-1 elevation |
| **FAB / Extended FAB** | `fab` | screen primary (Add Expense) | `primaryContainer`, level-3, `shape.full`, 56dp (regular) |
| **Icon button** | `iconButton` | app bar/list actions | 48dp target, 24dp icon |
| **Destructive** | `button.filled` + `error` | Delete | `error` bg, `onError` label |

**States:** rest / hover / focus / pressed / disabled (38% opacity) / loading (inline spinner, label hidden or "Saving…", disabled). Min width 48dp; horizontal padding 24dp (text 12dp). Pressed uses state-layer 12% overlay.

---

## 8. Cards

| Variant | Token | Use |
|---------|-------|-----|
| **Elevated** | `card.elevated` | trip cards on Home (level 1) |
| **Filled** | `card.filled` | budget summary, info blocks (`surfaceContainer`) |
| **Outlined** | `card.outlined` | secondary/grouped content (`outlineVariant` border) |

**Anatomy:** `shape.md` (12dp); padding 16dp; internal gap 12dp; optional leading media/avatar (40dp); title `titleMedium`, supporting `bodyMedium` (`onSurfaceVariant`); trailing amount/chevron. Full-card tap target where the card is a navigation entry. Status conveyed via chip + icon (not card color).

**Trip card spec:** title (name) + subtitle (destination · dates) + member avatar stack (max 4 + overflow count) + linear budget progress + spent/total caption + status chip.

---

## 9. Bottom Sheets

| Type | Use |
|------|-----|
| **Modal bottom sheet** | Invite, filters, reject-reason, paywall, action menus |
| **Standard (expanding)** | not used in v1.0 |

**Anatomy:** `shape.xl` top corners (28dp); 4dp drag handle (`outlineVariant`, centered, 32dp wide); content padding 24dp; title `titleLarge`; scrim `scrim` at 32% over content. Max height 90% viewport; scrollable content with sticky footer for primary action. Dismiss: drag-down, scrim tap, back gesture. Keyboard-aware (resizes for inputs).

---

## 10. Dialogs

| Type | Use |
|------|-----|
| **Basic alert** | confirmations (delete, archive, sign-out warning) |
| **Full-screen dialog** | not standard in v1.0 (use screens) |

**Anatomy:** `shape.xl` (28dp); `surfaceContainerHigh`, level-4; padding 24dp; optional 24dp leading icon (`secondary`); title `headlineSmall`; body `bodyMedium`; actions bottom-right — confirm (`button.text` or filled for destructive emphasis) + dismiss (`button.text`). Destructive confirm uses `error` label. Max width 560dp; scrim 32%. Focus trapped; ESC/back dismisses non-destructive.

---

## 11. Snackbars

**Use:** transient confirmations, undo, non-blocking errors. **Not** for critical/persistent states (use MaterialBanner).

**Anatomy:** `inverseSurface` bg, `inverseOnSurface` text (`bodyMedium`), optional single action (`primary`-tinted label, e.g. **Undo**), `shape.xs`; level-3; bottom, above FAB (FAB shifts up). One line preferred, max two. Duration: 4s default, 6–10s with action; persistent only for ongoing process. One snackbar at a time (queue). Swipe to dismiss. Action labels are verbs ("Undo", "Retry").

**Banner (persistent) vs Snackbar:** offline / over-budget → `MaterialBanner` (stays until resolved); save confirmations / undo → `SnackBar`.

---

## 12. Icons

- **Set:** Material Symbols (Rounded), weight 400, optical size 24, grade 0. Filled for selected/active nav, outlined for inactive.
- **Sizes:** 18dp (inline/badges), 24dp (default/list/buttons), 40dp (empty-state/feature), 48dp tap target.
- **Color:** `onSurfaceVariant` (default), `primary` (active/interactive), `error` (destructive), money/status colors where paired with text.
- **Category icon map:** food → `restaurant`, fuel → `local_gas_station`, accommodation → `hotel`, transport → `directions_car`, toll → `toll`, drinks → `local_bar`, shopping → `shopping_bag`, activities → `confirmation_number`, parking → `local_parking`, misc → `category`.
- **Status icons:** pending → `schedule`, approved → `check_circle`, rejected → `cancel`, settled → `task_alt`, over-budget → `warning`, offline → `cloud_off`, pending-sync → `sync`.
- **Rules:** every standalone icon has a semantic label; never icon-only for status without text nearby.

---

## 13. Dark Mode

### 13.1 Dark Roles
| Role | Value |
|------|-------|
| `surface` | `#0E1514` |
| `surfaceContainerLow` | `#151D1C` |
| `surfaceContainer` | `#1A2221` |
| `surfaceContainerHigh` | `#243130` |
| `onSurface` | `#DFE3E2` |
| `onSurfaceVariant` | `#BEC9C7` |
| `primary` | `#4FD8D5` |
| `onPrimary` | `#003735` |
| `primaryContainer` | `#00504E` |
| `onPrimaryContainer` | `#9FF3F0` |
| `error` | `#FFB4AB` |
| `outline` | `#899392` |

### 13.2 Rules
- True-dark base (`#0E1514`), not pure black (reduces smear on OLED while keeping depth).
- Elevation = **lighter tonal tint**, minimal shadow.
- Desaturate brand tones (use tone 80 for `primary`) to avoid glare; maintain AA contrast.
- Money/status colors swap to their dark variants (§2.4).
- Images/receipts get a subtle border in dark to separate from surface.
- Theme options: System / Light / Dark (Settings §3.18). Default = System.

---

## 14. Charts

**Library:** `fl_chart`. Charts always paired with a text/table equivalent (Accessibility).

### 14.1 Palette (categorical, color-blind-aware ordering)
`#0E7C7B` · `#4A5B8C` · `#9A5B00` · `#1E6E3A` · `#7A4FC2` · `#B5562B` · `#2E7DA1` · `#8A8D2E` · `#B03060` · `#5E5E5E` (misc). Reuse with pattern/label differentiation beyond 10 categories.

### 14.2 Types & Specs
| Chart | Use | Spec |
|-------|-----|------|
| **Pie/Donut** | category breakdown | donut (hole 55%), center = total; slices labeled with %; legend below with value table |
| **Bar** | spend by member | rounded bars (`shape.xs` top), `primary`/categorical fill; axis `bodySmall` `onSurfaceVariant` |
| **Line/Area** | spend timeline | 2dp stroke `primary`, soft area gradient; cumulative + daily toggle; gridlines `outlineVariant` |
| **Progress gauge** | budget pace | linear/arc; green→amber→red thresholds (under/near/over), with text % |

### 14.3 Rules
- Animate in ≤400ms (respect reduced-motion → no animation).
- Empty state per chart (no synthetic data).
- Tooltips on tap (touch-friendly), value + label.
- Always show a legend + accessible data summary.

---

## 15. Animations & Motion

### 15.1 Duration Tokens
| Token | ms | Use |
|-------|----|----|
| `motion.short1` | 100 | state-layer, ripple |
| `motion.short4` | 200 | small transitions, chips |
| `motion.medium2` | 300 | screen content, cards |
| `motion.long2` | 500 | container transform, charts |

### 15.2 Easing
| Token | Curve | Use |
|-------|-------|-----|
| `emphasized` | M3 emphasized | primary transitions |
| `emphasizedDecelerate` | enter | incoming elements |
| `emphasizedAccelerate` | exit | outgoing elements |
| `standard` | standard | small UI changes |

### 15.3 Patterns
- **List → detail:** container transform (card morphs to screen).
- **Tabs (shell):** shared-axis X.
- **Steps (auth/onboarding):** shared-axis X.
- **Bottom sheet/dialog:** fade-through + slide/scale (decelerate in, accelerate out).
- **FAB:** scale-in on screen enter; morph to extended on scroll-up.
- **Budget/number updates:** count-up tween ≤300ms; progress bar animates to new value.
- **Pending-sync resolve:** badge fade-out on confirmation.
- **Reduced motion:** replace transforms with cross-fades ≤100ms; disable count-ups and chart animations.
- **Performance:** all transitions ≤300ms perceived (Architecture §16); no jank on list scroll.

---

## 16. Material 3 Tokens (Reference Map)

| Category | Token namespace | Source §|
|----------|-----------------|---------|
| Color roles | `md.sys.color.*` (primary, surface, …) | §2, §13 |
| Typography | `md.sys.typescale.*` | §3 |
| Shape | `md.sys.shape.corner.*` | §5 |
| Elevation | `md.sys.elevation.level0–5` | §6 |
| Motion | `md.sys.motion.duration/easing.*` | §15 |
| State layers | `md.sys.state.hover/focus/pressed` (8/10/12% opacity) | §7 |
| Spacing (app) | `app.space.*` (4dp scale) | §4 |
| Semantic (app) | `app.color.success/warning/danger/money.*` | §2.4 |

**Implementation note:** tokens defined once in a single theme module; components reference tokens, never literals. Light/dark are two `ColorScheme`s from the same seed + the semantic extension set. Dynamic color (Android 12+) overrides scheme; semantic/money tokens remain fixed.

---

## 17. Accessibility (Design-Level)

| Area | Rule |
|------|------|
| Contrast | All role pairs AA (≥4.5:1 text, ≥3:1 large/icon); pre-validated in §2/§13 |
| Color independence | Status = color **+** icon **+** label always |
| Targets | ≥48×48dp; 8dp min gap |
| Dynamic type | Scale to 200%; layouts reflow; tabular money never clips |
| Focus | Visible focus ring (`primary`, 2dp); logical order; dialogs/sheets trap + restore focus |
| Motion | Honor reduced-motion (§15); no info conveyed solely by animation |
| Charts | Mandatory text/table equivalent (§14) |
| Labels | Every icon/control has a semantic label; headings structured per screen |
| Forms | Errors announced + tied to field; required + keyboard type exposed |
| Dark mode | Maintains all contrast rules; no pure-black smear |

---

## 18. Responsive Rules

### 18.1 Breakpoints (M3 window size classes)
| Class | Width | Layout |
|-------|-------|--------|
| **Compact** | < 600dp | phone portrait; `NavigationBar`; single column; 16dp padding; FAB |
| **Medium** | 600–839dp | phone landscape / small tablet; `NavigationRail`; 24dp padding; content max 640dp |
| **Expanded** | ≥ 840dp | tablet/desktop; `NavigationRail` (or drawer); **master-detail** (trip list + dashboard); 24dp padding |

### 18.2 Adaptive Behaviors
- **Navigation:** bottom `NavigationBar` (compact) → `NavigationRail` (medium/expanded) → optional `NavigationDrawer` (large expanded).
- **Lists/detail:** compact = stacked navigation; expanded = two-pane master-detail (Trips ↔ Dashboard, Expenses ↔ Detail).
- **Forms/dialogs:** centered, max-width 560dp on large screens.
- **Charts:** scale to container; legends move beside chart on wide layouts.
- **FAB:** bottom-right (compact) → top of rail or inline header (expanded).
- **Bottom sheets → side sheets / dialogs** on expanded where appropriate.
- **Orientation:** support both; preserve scroll/nav state across rotation.
- **Density:** comfortable (default, mobile); compact density allowed on expanded screens.

---

*This Design System is the single source of truth for TripMate's visual language. All tokens are defined once and consumed by name. Changes are versioned here and reviewed before implementation.*
