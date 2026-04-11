# Full Swift Chart Surface Expansion Implementation Plan

**Date:** 2026-04-09
**Project:** `SimpleChart`
**Status:** Draft plan ready for implementation

## Goal

Implement the next native API expansion so `SimpleChart` offers broad Swift Charts coverage through:

- ready-made wrappers as the default public API
- an exposed composable helper layer
- interaction-heavy support
- availability-gated newer features

## Principles

- keep wrappers easier to use than raw Swift Charts
- do not regress the existing deprecated legacy bridge
- prefer additive changes over rewrites where possible
- phase the work to keep each reviewable slice coherent

## Phase 1: Foundation Refactor

### Objective

Create the package-wide helper kernel that new wrappers will build on.

### Tasks

1. Add new shared models:
   - `SCChartBarGroup`
   - `SCChartStackSegment`
   - `SCChartScatterPoint`
   - `SCChartSectorSegment`
   - `SCChartTimePoint`
   - `SCChartBand`
   - `SCChartSelectionState`
   - `SCChartViewport`
2. Add helper factories from:
   - primitive arrays
   - labeled tuples
   - grouped tuples
   - stacked tuples
   - date/value tuples
3. Add public helper enums/structs for:
   - `SCChartMark`
   - `SCChartScale`
   - `SCChartOverlay`
   - `SCChartAnnotation`
   - `SCChartInteraction`
4. Add internal/public composition utilities to translate helper descriptors into `Chart` content.

### Verification

- builder tests for every new model/helper
- compile-safe helper construction tests

## Phase 2: Wrapper Family Expansion

### Objective

Fill the major static/compositional chart-family gaps.

### Tasks

1. Add wrappers for:
   - `SCNativeAreaChart`
   - `SCNativeScatterChart`
   - `SCNativeSectorChart`
   - `SCNativeDonutChart`
   - `SCNativeGroupedBarChart`
   - `SCNativeStackedBarChart`
   - `SCNativeThresholdChart`
   - `SCNativeGoalChart`
2. Add wrapper conveniences:
   - grouped datasets
   - stacked datasets
   - segmented sector data
   - date-series helpers
3. Unify wrapper naming/default behavior with the new helper kernel.

### Verification

- wrapper-state tests for each new family
- domain/range tests for grouped/stacked/sector behavior

## Phase 3: Composed Chart Support

### Objective

Expose a general-purpose composed chart entry point that can combine multiple mark types.

### Tasks

1. Add `SCComposedChart`
2. Support composed mark arrays:
   - line
   - area
   - point
   - bar
   - range/rectangle
   - rule
   - sector
3. Support composition-level:
   - scales
   - axes
   - legends
   - overlays
   - annotations
4. Reuse `SCComposedChart` internally where it reduces wrapper duplication.

### Verification

- state tests for mixed-mark combinations
- overlay and annotation helper tests

## Phase 4: Interaction Layer

### Objective

Add first-class support for interactive chart behavior.

### Tasks

1. Add selection helpers and wrappers:
   - `SCSelectableLineChart`
   - `SCSelectableBarChart`
   - `SCSelectableScatterChart`
2. Add visible-domain and viewport helpers:
   - `SCChartVisibleDomain`
   - `SCChartViewport`
3. Add scrolling wrappers:
   - `SCScrollableLineChart`
   - `SCScrollableTimeSeriesChart`
4. Add inspection overlays and callout helpers.

### Verification

- interaction state tests
- selection binding tests
- viewport normalization tests

## Phase 5: Time-Series and Axis Expansion

### Objective

Make date/time and formatted-axis scenarios first-class.

### Tasks

1. Add date/time dataset builders
2. Add time-series-focused wrappers
3. Add axis formatting helpers for:
   - compact numbers
   - currency
   - percent
   - dates/times
4. Add scale presets for:
   - category
   - numeric
   - date/time
   - fixed
   - visible-window

### Verification

- time-series builder tests
- formatter/scale tests

## Phase 6: Availability-Gated Feature Layer

### Objective

Surface newer Swift Charts features without destabilizing baseline wrappers.

### Tasks

1. Audit first-party APIs above package minimums
2. Add availability-gated wrappers/helpers in isolated files
3. Ensure wrappers/helpers use native `@available(...)` annotations
4. Keep baseline wrapper behavior independent from gated features

### Verification

- compile checks for gated files
- baseline build verification remains clean on minimum-target package configuration

## Phase 7: Documentation and Migration

### Objective

Keep the package discoverable as the surface area grows.

### Tasks

1. Rewrite README sections around:
   - wrapper catalog
   - helper catalog
   - interaction support
   - availability notes
2. Add migration guidance that distinguishes:
   - deprecated legacy API
   - easy wrappers
   - advanced composable helpers
3. Update changelog for each delivered phase
4. Add targeted examples in sample/demo content

## Phase 8: Verification and Stabilization

### Objective

Prove the package is still coherent after the expansion.

### Tasks

1. Run `swift build`
2. Run `swift test`
3. Review warning surface
4. Audit naming consistency and access control
5. Confirm deprecated legacy tests still pass

## Recommended Execution Order

This should not be attempted as a single uninterrupted patch. Recommended rollout:

1. Phase 1
2. Phase 2
3. Phase 3
4. Phase 4
5. Phase 5
6. Phase 6
7. Phase 7
8. Phase 8

If implementation needs to be split into multiple user-visible milestones, the cleanest milestone cuts are:

- Milestone A: static wrapper and helper kernel expansion
- Milestone B: composed chart and annotation system
- Milestone C: interaction and time-series support
- Milestone D: availability-gated newer features and polish

## Review

- This plan assumes the existing native helper expansion remains the foundation rather than being discarded.
- The package should stay wrapper-first even as the helper system becomes more capable.
- Interaction and availability work are intentionally delayed until after the composition kernel is in place, because otherwise those features will be duplicated across wrappers.
