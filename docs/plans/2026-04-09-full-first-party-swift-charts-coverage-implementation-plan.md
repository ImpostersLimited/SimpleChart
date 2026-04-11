# Full First-Party Swift Charts Coverage Implementation Plan

**Date:** 2026-04-09  
**Project:** `SimpleChart`  
**Status:** Draft plan ready for execution

## Goal

Close the gap between the current broad native wrapper/helper surface and full first-party Swift Charts concept coverage by:

- completing the public helper kernel
- adding wrapper families where a first-party concept maps to a clear product-style chart
- isolating newer Apple chart APIs behind native availability annotations
- preserving the current wrapper-first onboarding path

## Execution Principles

- complete helper-kernel coverage before adding large numbers of one-off wrappers
- keep wrappers easier to use than raw `Charts`
- prefer additive, reviewable slices over broad rewrites
- verify every slice with `swift build` and `swift test`
- update docs and support-matrix notes as each capability family lands

## Phase 1: Support Matrix and Helper-Kernel Gaps

### Objective

Turn the current design into code-level execution targets.

### Tasks

1. Add an internal support checklist by capability family:
   - marks
   - axes
   - scales/domains
   - legends
   - overlays/annotations
   - interactions
   - availability-gated newer APIs
2. Audit the existing helper kernel and identify where package-owned helper types are still missing.
3. Expand public helper types to make the remaining first-party concepts representable even before wrapper families land.

### Deliverables

- expanded helper enums/structs in `Native/Core`, `Native/Marks`, and `Native/Composition`
- updated design references in docs and task notes

## Phase 2: Axis, Legend, and Plot-Style Completeness

### Objective

Make axis/legend/plot behavior first-class package concepts instead of scattered wrapper parameters.

### Tasks

1. Add explicit helper types for:
   - `SCChartAxis`
   - `SCChartAxisMarks`
   - `SCChartLegend`
   - `SCChartPlotStyle`
2. Expand `SCChartScale` and `SCChartVisibleDomain` to represent:
   - domain padding policies
   - visible-window policies
   - grouping/stacking interpretation where relevant
3. Route existing wrappers and `SCComposedChart` through these helpers.

### Verification

- state tests for axis/legend/plot-style helpers
- wrapper-state tests showing the new helpers integrate cleanly

## Phase 3: Remaining 2D Mark Families

### Objective

Finish the baseline 2D first-party mark surface.

### Tasks

1. Expand `SCChartMark` so all supported 2D first-party mark concepts are modeled explicitly.
2. Add dedicated wrapper families where they are product-useful:
   - `SCRuleChart`
   - `SCRectangleChart`
   - `SCBandChart` or equivalent range-band wrapper
   - richer sector/donut configuration wrappers if needed
3. Add helper coverage for:
   - symbol sizing/styling
   - stacking/grouping policies where relevant
   - mark-level styling that is still missing from the current helper surface

### Verification

- composed-chart tests for each new mark type
- focused wrapper-state tests for any new standalone wrapper

## Phase 4: Inspection, Crosshair, and Overlay Completeness

### Objective

Complete the remaining high-value inspection and annotation behavior.

### Tasks

1. Add shared crosshair and inspector helper models.
2. Add wrappers such as:
   - `SCInspectorLineChart`
   - `SCCrosshairTimeSeriesChart`
3. Expand annotation/overlay helpers to support:
   - plot-area callouts
   - crosshair labels
   - coordinated x/y inspection behavior
   - richer anchor/placement policies
4. Unify hover, selection, and inspector rendering through one shared inspection path.

### Verification

- helper tests for inspection state
- wrapper tests for crosshair/inspector configuration

## Phase 5: Time-Series and Scale Behavior Completeness

### Objective

Finish the package’s modeling of first-party time and numeric behavior.

### Tasks

1. Add richer date/time axis policies and presets.
2. Add more direct wrappers for common timeline scenarios where they improve discoverability.
3. Expand visible-window and viewport helpers with:
   - pinch/zoom-style window calculations
   - coordinated scrolling/selection helpers
   - preset behaviors for finance and analytics charts
4. Expand formatter coverage as needed for compact/currency/percent/date use cases.

### Verification

- time-series formatter tests
- visible-window and viewport math tests
- wrapper-state tests for new timeline presets

## Phase 6: Availability-Gated Newer Charts Surface

### Objective

Add the newer Apple chart APIs that sit above the package baseline.

### Tasks

1. Add availability-gated helper models for:
   - vectorized plots
   - 3D chart composition
   - surface plots
2. Add wrapper families where appropriate:
   - `SCVectorizedPlotChart` or equivalent helper-first surface
   - `SCChart3D`
   - `SCSurfacePlotChart`
3. Keep all newer APIs isolated in dedicated files under `Native/Availability` or equivalent.

### Verification

- compile-safe availability checks
- minimum-target baseline build remains clean
- tests for helper/model normalization that do not require runtime-only availability features unless those tests are properly gated

## Phase 7: Wrapper Catalog and Docs Completion

### Objective

Keep the package discoverable once full first-party concept coverage exists.

### Tasks

1. Update `README.md` so it distinguishes:
   - easy wrappers
   - advanced helper kernel
   - availability-gated wrappers
2. Update `docs/getting-started.md` only where first-use guidance changes.
3. Add a dedicated support-matrix doc or README section summarizing:
   - fully covered
   - availability-gated
   - wrapper-first recommendations
4. Update `docs/chart-selection-guide.md` to include the new wrapper families.
5. Update `CHANGELOG.md` after each meaningful slice.

## Phase 8: Final Verification and Surface Review

### Objective

Prove that the package is coherent after reaching the full-support target.

### Tasks

1. Run `swift build`
2. Run `swift test`
3. Review warning surface
4. Review naming consistency across:
   - wrappers
   - helper kernel
   - availability-gated types
5. Confirm legacy bridge tests still pass and remain intentionally deprecated-only
6. Re-check onboarding docs so new users still see the easy path first

## Recommended Execution Order

1. Phase 1
2. Phase 2
3. Phase 3
4. Phase 4
5. Phase 5
6. Phase 6
7. Phase 7
8. Phase 8

## Practical Milestone Cuts

If the work needs to be shipped in smaller user-visible slices, the cleanest cuts are:

- Milestone A: helper-kernel completeness for axes/legends/plot styles
- Milestone B: remaining 2D mark and overlay wrappers
- Milestone C: inspection and time-series completeness
- Milestone D: availability-gated vectorized/3D/surface support

## Review

- The current package is already beyond “starter wrapper” scope; this plan avoids throwing away that progress.
- The main change is elevating the helper kernel to true first-party concept completeness so wrapper growth stops being ad hoc.
- The riskiest phase is the availability-gated newer Apple chart APIs, so it should come after the baseline helper and wrapper surface is stable.
