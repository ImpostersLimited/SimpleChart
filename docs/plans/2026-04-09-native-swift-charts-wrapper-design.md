# Native Swift Charts Wrapper Design

**Date:** 2026-04-09
**Project:** `SimpleChart`
**Status:** Approved design, pending implementation plan

## Goal

Add a new native-first wrapper layer around Apple's first-party Swift Charts framework so the package has a cleaner modern API, while preserving backward compatibility through deprecated bridges from the current `SC*` data, config, and view types.

## Current State

The package is currently organized around one custom renderer per chart family:

- `SCBarChart`
- `SCHistogram`
- `SCLineChart`
- `SCQuadCurve`
- `SCRangeChart`

Each family has its own:

- `Data` type
- `Config` type
- `View`
- internal renderer helpers

`SCManager` provides convenience conversion from primitive arrays into the package-specific data types.

The package currently targets pre-Swift-Charts OS versions in `Package.swift`, and test coverage is effectively absent.

## Constraints

- The new design must cover all existing chart families.
- The package should adopt Swift Charts-supported minimum deployment targets instead of maintaining fallback renderers for older OS versions.
- The new API should be parallel to the old one, not an in-place mutation of the old public surface.
- The old public API should remain in the package for backward compatibility.
- The old public API should be deprecated and bridged onto the new native layer.
- Existing custom renderer files should remain in the package and be marked deprecated-only; they should not be removed in this work.

## Recommended Approach

Introduce a new native-first API as the package's primary public surface and keep the existing API as a compatibility shim.

This is preferable to rewriting the old API in place because:

- it produces an actually cleaner package surface rather than preserving the existing config-heavy shape
- it allows documentation to clearly distinguish "preferred" and "legacy" usage
- it avoids coupling the new design to old naming and old initialization semantics
- it keeps migration low-risk because existing callers still compile

## Platform Strategy

Update `Package.swift` minimum deployment targets to Swift Charts baselines:

- iOS 16
- macOS 13
- tvOS 16
- watchOS 9
- macCatalyst 16

This removes the need for runtime fallback behavior and lets the bridge target the same native rendering stack as the new API.

## Target Architecture

Add a new native layer with focused responsibilities:

- `Sources/SimpleChart/Native/Core/`
- `Sources/SimpleChart/Native/Models/`
- `Sources/SimpleChart/Native/Charts/`
- `Sources/SimpleChart/LegacyBridge/`

### Native Models

The new API should avoid one config type per chart family unless the chart semantics truly differ.

Recommended model split:

- `SCChartPoint`
  - a single plotted value with optional x-domain identity or label
- `SCChartRangePoint`
  - lower/upper values for range-oriented charts
- `SCChartSeriesStyle`
  - color, line/fill choices, interpolation, stroke choices
- `SCChartAxesStyle`
  - axis visibility, grid visibility, y-axis labeling, legends
- `SCChartDomain`
  - domain/range behavior, base-zero behavior, explicit min/max override
- lightweight per-chart option wrappers only when needed for chart-specific behavior

### Native Views

Recommended new public views:

- `SCNativeBarChart`
- `SCNativeHistogramChart`
- `SCNativeLineChart`
- `SCNativeQuadCurveChart`
- `SCNativeRangeChart`

These names can still be refined during implementation planning, but the important point is that the new views must be clearly separable from the legacy `SC*Chart` types.

## Chart Mapping Strategy

### Bar Chart

Use `BarMark`.

This is a direct native mapping and should be the baseline for validating the new API shape.

### Histogram

Use `BarMark`, backed by a small binning layer.

The histogram wrapper should support either:

- pre-binned data, or
- raw numeric input plus a binning strategy

The first implementation should keep the binning story simple and deterministic so it is easy to test.

### Line Chart

Use `LineMark`.

Optionally compose with `AreaMark` when the old config semantics imply filled-line behavior.

### Quad Curve

Use `LineMark` with the closest first-party interpolation method available in Swift Charts.

This will not be a pixel-identical port of the current custom quadratic renderer, so the design should treat it as a semantic native approximation rather than a strict visual clone.

### Range Chart

Use a vertical span composition such as:

- `RuleMark` for lower-to-upper ranges, or
- `RectangleMark`/bar-like composition if that yields better control over thickness and shape

The implementation plan should validate which mark combination best approximates the current capsule-style appearance.

## Legacy Bridge Strategy

Keep the old public API types:

- old `SC*ChartData`
- old `SC*ChartConfig`
- old `SC*Chart` views
- `SCManager`

Bridge them onto the new native layer:

- add adapter code that translates each legacy data/config family into native models and style options
- update legacy public views to delegate rendering to the new native views
- mark legacy public types as deprecated with migration guidance toward the new API
- mark old custom renderer internals as deprecated where publicly visible or otherwise clearly legacy in code organization

The bridge should preserve behavior where reasonable, especially:

- default data replacement when the old config receives empty data
- base-zero handling
- min/max override semantics
- interval/grid visibility
- axis toggles

Where exact visual parity is not possible, the implementation plan should call out the differences explicitly.

## File-Level Design Direction

### Existing files likely to change

- `Package.swift`
- `README.md`
- `Sources/SimpleChart/SCManager.swift`
- `Sources/SimpleChart/SCBarChart/*`
- `Sources/SimpleChart/SCHistogram/*`
- `Sources/SimpleChart/SCLineChart/*`
- `Sources/SimpleChart/SCQuadCurve/*`
- `Sources/SimpleChart/SCRangeChart/*`
- `Tests/SimpleChartTests/*`

### New files likely to be added

- native shared model files
- native shared style/domain files
- native chart wrapper views for each chart family
- legacy adapter files per chart family
- targeted tests for adapters, domain calculations, and histogram binning

## Migration and Documentation Strategy

The README should be restructured so the new API is shown first and the legacy API is explicitly presented as compatibility-only.

Documentation should include:

- new quick-start examples
- a migration section from legacy config/data APIs to the new native-first API
- deprecation notes for `SCManager` helpers and old chart/config/data types

## Testing Strategy

Implementation should introduce meaningful automated coverage around:

- adapter correctness from legacy types to native models
- base-zero and domain calculations
- explicit min/max override behavior
- histogram bin generation
- representative construction of each native chart family

Even if full visual snapshot testing is deferred, the planning work should assume structure-level tests and behavior-level tests are required.

## Risks

### Visual Drift

The native Swift Charts wrappers will not match all current custom-drawn charts exactly, especially `SCQuadCurve` and possibly `SCRangeChart`.

### Legacy Semantics Creep

If the bridge attempts to preserve every historical quirk, the new API design could get polluted by legacy constraints.

### Overgeneralized Shared Model

If the shared native model is made too abstract, the new API may become harder to use than necessary. The implementation plan should prefer a small common core with thin chart-specific wrappers.

## Recommendation Summary

Proceed with:

1. raised package minimum deployment targets
2. a new native-first public API built on Swift Charts
3. per-chart compatibility adapters from old types to new types
4. deprecated-but-preserved legacy API and renderer code
5. documentation and tests that make the migration path explicit

## Review

- Project structure reviewed against current package layout
- Native API direction chosen: additive parallel layer
- Backward compatibility direction chosen: preserve old API, bridge, deprecate
- Platform direction chosen: raise minimum OS targets to Swift Charts era
- Chart-family scope chosen: include all existing chart families
