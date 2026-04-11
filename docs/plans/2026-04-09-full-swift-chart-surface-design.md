# Full Swift Chart Surface Expansion Design

**Date:** 2026-04-09
**Project:** `SimpleChart`
**Status:** Approved design, pending implementation

## Goal

Expand `SimpleChart` from a small native-wrapper package into a broad, helper-first Swift Charts toolkit that:

- keeps ready-made wrappers as the primary public API
- exposes the composable helper layer used by those wrappers
- covers both static and interaction-heavy chart use cases
- surfaces newer first-party chart APIs behind native availability annotations
- remains easier to use than raw Swift Charts for common product work

This expansion is not intended to be a one-to-one alias of the entire `Charts` framework. The package should provide productized wrappers and helper abstractions that make the first-party system easier to adopt, while still making most practical Swift Charts capabilities available.

## Current State

The package now has:

- a native-first chart layer for bar, histogram, line, quad-curve, range, and multi-line charts
- shared helpers for points, ranges, domains, styles, axes, and reference lines
- a deprecated legacy compatibility bridge from the original `SC*` API

Current native surface strengths:

- primitive array and labeled-value helpers
- line, bar, range, histogram, and multi-line wrappers
- simple threshold and average reference-line support
- basic domain and style presets

Current native surface gaps relative to Swift Charts:

- no grouped or stacked bar wrappers
- no dedicated area, point/scatter, sector/donut, rectangle, or rule wrappers
- no generic composition engine for mixed-mark charts
- no annotation system beyond reference lines
- no public interaction model for selection, visible domain, scrolling, or overlays
- no time-series-first API surface
- no helper model for grouped, stacked, segmented, or date-based datasets
- no public availability-gated wrappers for newer first-party chart features

## Product Direction

The package should be explicitly two-layered.

### Layer 1: Ready-Made Wrappers

This is the primary public experience. It should be the fastest route for most consumers.

Examples of the target wrapper family:

- `SCLineChart`
- `SCMultiLineChart`
- `SCAreaChart`
- `SCBarChart`
- `SCGroupedBarChart`
- `SCStackedBarChart`
- `SCHistogramChart`
- `SCRangeChart`
- `SCScatterChart`
- `SCSectorChart`
- `SCDonutChart`
- `SCThresholdChart`
- `SCGoalChart`
- `SCScrollableLineChart`
- `SCSelectableLineChart`
- `SCSelectableBarChart`
- `SCVisibleDomainTimeSeriesChart`
- `SCComposedChart`

Wrapper names can still be refined before implementation, but the package should converge on a clear naming system with:

- plain wrapper names for common chart families
- specialized names only when interaction or composition meaningfully changes the contract

### Layer 2: Exposed Composable Helper System

The wrapper layer should be built on top of reusable public helpers that advanced users can opt into directly.

This helper system should expose:

- data models
- mark descriptors
- domain/scale helpers
- axis helpers
- annotation helpers
- overlay helpers
- interaction state helpers
- viewport helpers
- availability-gated feature helpers

The wrappers should be thin presets around this helper layer rather than parallel implementations.

## Recommended Architecture

Add and reorganize native code under the following structure:

- `Sources/SimpleChart/Native/Models/`
- `Sources/SimpleChart/Native/Marks/`
- `Sources/SimpleChart/Native/Core/`
- `Sources/SimpleChart/Native/Composition/`
- `Sources/SimpleChart/Native/Interactions/`
- `Sources/SimpleChart/Native/Wrappers/`
- `Sources/SimpleChart/Native/Availability/`

The existing native chart files can be retained initially and migrated into the new structure incrementally if that keeps the diff safer.

### Models

Add or expand shared data helpers for:

- `SCChartPoint`
- `SCChartRangePoint`
- `SCChartLineSeries`
- `SCChartBarGroup`
- `SCChartStackSegment`
- `SCChartScatterPoint`
- `SCChartSectorSegment`
- `SCChartTimePoint`
- `SCChartReferenceLine`
- `SCChartBand`
- `SCChartAnnotation`
- `SCChartViewport`
- `SCChartSelection`

Model principles:

- strong semantic types for common product charting tasks
- helper factories from primitive arrays, tuples, labeled values, grouped values, and date-based inputs
- explicit normalization at the model layer where it reduces downstream ambiguity

### Mark Helper Layer

Expose a public mark descriptor family that is easier to use than raw Swift Charts marks but still composable:

- `SCChartMark.line(...)`
- `SCChartMark.area(...)`
- `SCChartMark.bar(...)`
- `SCChartMark.point(...)`
- `SCChartMark.range(...)`
- `SCChartMark.rule(...)`
- `SCChartMark.rectangle(...)`
- `SCChartMark.sector(...)`
- `SCChartMark.annotation(...)`

This layer is for package-level composition, not for mirroring every single `Mark` API detail. The mark descriptors should capture the high-frequency parameters and keep the wrappers internally consistent.

### Composition Layer

Introduce a reusable chart composition engine, likely centered on:

- `SCComposedChart`
- `SCChartComposition`
- `SCChartScale`
- `SCChartXAxis`
- `SCChartYAxis`
- `SCChartLegend`
- `SCChartOverlay`

This layer should power:

- mixed mark charts
- combo charts
- overlays and threshold systems
- wrapper implementation reuse

The composition layer should be public so advanced users can escape the wrapper presets without dropping all the way to raw Swift Charts.

### Interaction Layer

Add explicit helper models for interaction-heavy features:

- `SCChartSelectionState<Value>`
- `SCChartScrollBehavior`
- `SCChartVisibleDomain`
- `SCChartInspectionOverlay`
- `SCChartHoverState`
- `SCChartGestureConfiguration`

These should drive wrappers such as:

- `SCSelectableLineChart`
- `SCSelectableBarChart`
- `SCScrollableLineChart`
- `SCVisibleDomainTimeSeriesChart`

Interaction helpers should be designed to support:

- binding-based selection
- optional callout/inspection overlays
- visible-domain windows and scrolling
- hover-style inspection on platforms that support it

### Availability Layer

For features that only exist on newer OS versions than the package minimum:

- expose them publicly with native `@available(...)`
- isolate them in separate files and wrappers
- avoid contaminating baseline wrappers with heavy conditional logic

This should apply to:

- interaction features whose first-party implementation is only available on newer baselines
- newer axis/scroll APIs
- any future Swift Charts additions surfaced by the package

## Public API Shape

### Ready-Made Wrappers

The wrapper layer should favor compact, helper-oriented initializers:

```swift
SCLineChart(values: [2, 5, 3, 7])

SCGroupedBarChart(
    groups: [
        .make(label: "Q1", values: [("Revenue", 20), ("Cost", 12)]),
        .make(label: "Q2", values: [("Revenue", 24), ("Cost", 14)])
    ]
)

SCDonutChart(
    segments: [
        .make("Free", 120),
        .make("Paid", 35)
    ]
)

SCSelectableLineChart(
    series: revenueSeries,
    selection: $selectedPoint
)
```

Wrapper rules:

- prefer convenience constructors over config trees
- expose advanced tuning only where it materially changes the chart
- use shared helper types consistently across wrappers

### Composable Helpers

Advanced callers should be able to build mixed charts like:

```swift
SCComposedChart(
    marks: [
        .line(revenueSeries),
        .area(revenueSeries, opacity: 0.2),
        .rule(.threshold(20, label: "Target")),
        .point(highlightSeries)
    ],
    xScale: .category(),
    yScale: .auto(baseZero: true),
    interaction: .selection($selection),
    overlay: .inspection
)
```

This must remain easier to use than raw Swift Charts. That means:

- typed presets instead of long modifier chains
- built-in default domains, legends, and overlays
- helper factories for common analytics and product charts

## Scope of Feature Coverage

The package should aim to cover all practical Swift Charts feature families through wrappers or helpers.

### Static and Compositional Coverage

- line
- area
- point/scatter
- bar
- grouped bar
- stacked bar
- histogram
- range
- rectangle-based spans/bands
- rule/threshold
- sector/pie/donut
- mixed-mark composed charts

### Data and Scale Coverage

- categorical x-values
- numeric x-values
- date/time x-values
- automatic, fixed, and visible domains
- grouped, stacked, segmented, and ranged datasets
- axis label formatting helpers

### Annotation and Overlay Coverage

- threshold lines
- average lines
- min/max lines
- goal bands
- point callouts
- annotation labels
- inspection overlays

### Interaction Coverage

- selection
- hover/inspection
- visible-domain windows
- scrolling
- viewport bindings
- availability-gated newer interactions where supported

## What “All Possible API” Means Here

The user requested support for all possible Swift Charts API through easier helpers. In package terms, that should mean:

- every major first-party charting capability has either:
  - a ready-made wrapper, or
  - a composable helper path
- the package does not need to reproduce every low-level modifier one-for-one if the underlying helper system remains open enough for practical use

The package should not try to become an exhaustive mirror of every `Charts` symbol. That would destroy the easier-to-use goal.

## Naming and Backward Compatibility

Keep the existing deprecated legacy bridge intact.

For the expanded native layer:

- prefer clean top-level wrapper names if feasible
- retain the current native naming if a rename would create unnecessary migration churn

A reasonable final direction is:

- keep the deprecated original legacy `SCLineChart`, `SCBarChart`, etc. for backward compatibility
- continue the native-first wrapper family under distinct names if naming collisions remain a problem

This naming decision should be finalized in implementation planning after reviewing symbol collisions and migration cost.

## Testing Strategy

This expansion needs broader test coverage than the current wrapper-state tests.

Required test categories:

- model builder tests
- grouped/stacked data normalization tests
- domain and visible-domain tests
- interaction state tests
- availability-gated compile tests where practical
- wrapper-state tests for each new wrapper family
- composition tests for `SCComposedChart`

Visual snapshot testing is still optional, but state and behavior coverage should be broad enough to safely evolve the helper layer.

## Risks

### API Sprawl

If wrappers and helpers are added without a clear system, the package will become incoherent.

Mitigation:

- shared helper system first
- wrappers as curated presets over that system

### Recreating Raw Swift Charts Complexity

If the helper layer is too literal, users will still need to think in raw `Charts` terms.

Mitigation:

- keep helper inputs semantic and task-oriented
- prefer model helpers and defaults over config nesting

### Availability Fragmentation

Exposing newer features behind `@available` gates can create a fractured API if done carelessly.

Mitigation:

- isolate newer features into additive wrappers/helpers
- keep baseline wrappers coherent at minimum deployment targets

### Large Diff Risk

This is too large for a single undifferentiated patch.

Mitigation:

- phase implementation around helper kernel first, then wrapper families, then interactions, then availability-gated features

## Recommendation Summary

Proceed with:

1. a two-layer architecture: ready-made wrappers plus public composable helpers
2. a shared helper kernel for marks, scales, overlays, and interactions
3. broad wrapper coverage for all major Swift Charts families
4. interaction-heavy support as first-class package features
5. native availability gating for newer APIs
6. phased implementation to keep the package stable and reviewable

## Review

- Scope approved: wrappers as primary API, helper layer publicly exposed
- Scope approved: interaction-heavy chart support included
- Scope approved: newer first-party features exposed with native availability annotations
- Architecture recommendation: wrapper-first package built on a public composable helper kernel
