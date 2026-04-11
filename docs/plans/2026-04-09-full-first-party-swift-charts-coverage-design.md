# Full First-Party Swift Charts Coverage Design

**Date:** 2026-04-09  
**Project:** `SimpleChart`  
**Status:** Design approved locally, implementation pending

## Goal

Expand `SimpleChart` from a broad wrapper/helper package into a package that can express the full first-party Swift Charts feature surface through:

- ready-made wrapper views for common chart tasks
- a public helper/composition kernel that covers every first-party chart concept
- availability-gated wrappers and helpers for newer Apple chart APIs
- a wrapper-first API that still stays easier to use than raw `Charts`

This does **not** mean re-exporting Apple types directly. It means every first-party chart concept should be representable through `SimpleChart` abstractions, with wrappers on top where those abstractions form recognizable product-level chart patterns.

## Scope Definition

For this expansion, `100% support` means:

1. Every first-party Swift Charts concept that is usable by application code is representable through public `SimpleChart` helper types.
2. Every first-party chart concept with a strong product-oriented default also has at least one wrapper-style entrypoint.
3. APIs that are only available on newer OS versions remain exposed through native `@available(...)` annotations instead of weakening package minimums.
4. Existing easy wrappers remain the preferred first-use surface.

It does **not** require:

- mirroring Apple names one-for-one
- exposing every modifier as a direct package-owned synonym if the helper layer already models the concept cleanly
- removing or rewriting the existing legacy bridge

## Current Support Matrix

### Fully Covered Today

- core single-series wrappers:
  - line
  - area
  - bar
  - histogram
  - range
  - quad-curve
  - scatter
- core multi-series/category wrappers:
  - multi-line
  - grouped bar
  - stacked bar
- composition/category wrappers:
  - sector
  - donut
  - threshold
  - goal
  - composed mixed-mark charts
- interaction wrappers:
  - selectable line, bar, scatter
  - selectable sector and donut
  - hoverable line, bar, scatter
  - scrollable line and time series
- helper families:
  - point/range/time/group/stack/sector/band/reference models
  - axes/domain/style/value-format helpers
  - selection/hover/scroll/viewport helpers
  - mark composition via `SCChartMark`

### Partially Covered Today

- first-party mark surface:
  - `LineMark`
  - `AreaMark`
  - `PointMark`
  - `BarMark`
  - `RuleMark`
  - `RectangleMark`
  - `SectorMark`
  - these are modeled, but not every useful configuration form is surfaced as helper abstractions or wrappers
- annotations and overlays:
  - value labels, badges, thresholds, bands, and simple inspection overlays exist
  - richer callout placement, crosshair composition, and plot-area inspection policies are not fully modeled
- axes and scales:
  - category/numeric/date formatting helpers exist
  - fuller axis-mark policies, tick density control, domain padding, scale behavior, and legend composition are only partially surfaced
- interactions:
  - selection, hover, scrolling, and viewport helpers exist
  - richer chart-proxy-driven inspection and coordinated zoom/pan behavior are not yet first-class across all compatible wrappers

### Not Yet Covered

These are the main remaining first-party chart capability families that still need package-owned support:

- fuller mark-configuration coverage:
  - symbol sizing and style variations
  - line/area stacking behavior helpers
  - rectangle/rule wrapper families as first-class ready-made views
  - richer sector/donut configuration
- axis and legend systems:
  - explicit x/y axis helper descriptors
  - custom axis-mark strategies
  - legend visibility and placement policies as first-class helpers
- chart-level style/composition:
  - foreground-style scale helpers
  - position/stacking/grouping strategies as first-class public helpers
  - plot-style and background helpers
- inspection and overlay behavior:
  - crosshair wrappers
  - inspector wrappers
  - coordinated overlay/callout placement helpers
- broader time-series helpers:
  - visible-window presets
  - larger-scale time axis policies
  - more direct wrappers for common finance/analytics timelines
- newer Apple chart APIs not yet represented in package helpers:
  - vectorized plots
  - `Chart3D`
  - `SurfacePlot`
  - any additional chart-only APIs that require newer availability than the current package minimum

## First-Party Coverage Buckets

The remaining work should be organized by framework concept, not by wrapper count.

### 1. Marks and Mark Families

Public helper coverage should explicitly model:

- line
- area
- point
- bar
- rule
- rectangle
- sector
- vectorized plot
- surface plot

Ready-made wrappers should exist where the mark maps to a commonly used standalone chart:

- rule chart
- rectangle/range-band chart
- sector and donut
- scatter
- surface and 3D wrappers where the APIs exist and are mature enough for helper-style defaults

### 2. Axes, Scales, Domains, Legends

The package should expose public helpers for:

- x and y axis descriptors
- domain behavior
- visible domain behavior
- scale kind and grouping/stacking interpretation
- legend visibility and placement
- foreground style scale and category styling

These helpers should be usable both from wrappers and from `SCComposedChart`.

### 3. Annotations and Overlays

The package should expose:

- point annotations
- band annotations
- threshold annotations
- badge/caption/value-label presets
- crosshair overlays
- inspector overlays
- plot-area callouts

### 4. Interaction Families

Public helper coverage should model:

- x/y/value selection
- angle selection for sector charts
- hover inspection
- scrolling
- visible-domain window binding
- zoom/clamp/window coordination
- chart proxy driven inspection behavior where the platform allows it

### 5. Availability-Gated Newer Framework Surface

Separate files and wrappers should expose newer APIs using native annotations, likely including:

- `SectorMark` features already partially covered
- vectorized plots
- 3D chart containers
- surface plots
- any newer interaction or axis APIs unavailable on the baseline deployment targets

## Recommended Public Architecture

The package should now be treated as three stacked layers.

### Layer 1: Ready-Made Wrappers

This remains the default user path.

Examples:

- `SCLineChart`
- `SCBarChart`
- `SCScatterChart`
- `SCSectorChart`
- `SCDonutChart`
- `SCRuleChart`
- `SCThresholdChart`
- `SCGoalChart`
- `SCInspectorLineChart`
- `SCCrosshairTimeSeriesChart`
- availability-gated wrappers for 3D and surface concepts

### Layer 2: Full Helper Kernel

This becomes the completeness layer for first-party coverage.

Core helper families:

- `SCChartMark`
- `SCChartAxis`
- `SCChartLegend`
- `SCChartScale`
- `SCChartDomain`
- `SCChartOverlay`
- `SCChartAnnotation`
- `SCChartInteraction`
- `SCChartViewport`
- `SCChartPlotStyle`

This layer must be expressive enough that any first-party chart concept can be represented here even when no dedicated wrapper exists yet.

### Layer 3: Renderer / Translation Layer

This remains internal.

It translates package-owned helper descriptors into:

- baseline `Chart`
- availability-gated chart features on newer OS versions
- future 3D chart or vectorized plot rendering paths

This layer should absorb Apple API shape changes so the public package surface stays coherent.

## Naming and Surface Rules

- keep wrapper names short and task-oriented
- keep helper names centered on chart concepts, not implementation details
- avoid exposing raw Swift Charts types directly in the public API where a package-owned helper can carry the meaning
- use additive, availability-gated wrapper names instead of optional flags when a feature only exists on newer OS versions

## Recommended Next Milestones

### Milestone A: Completeness Kernel

- add explicit axis, legend, interaction, and plot-style helper types
- expand `SCChartMark` to model the remaining first-party mark families
- normalize composed-chart rendering through the fuller helper kernel

### Milestone B: Inspection and Overlay Completeness

- add crosshair and inspector helpers
- add rule/rectangle wrappers
- unify annotation and overlay rendering across wrappers

### Milestone C: Time-Series and Scale Completeness

- expand axis/scale behaviors
- add richer visible-window and formatting presets
- add finance/analytics timeline wrappers where they are real product patterns

### Milestone D: Availability-Gated Newer APIs

- add vectorized plot support
- add `Chart3D` support
- add `SurfacePlot` support
- keep these isolated behind native availability annotations

## Risks

- If the package tries to mirror Apple APIs too literally, it will stop being easier to use.
- If wrappers keep being added without expanding the helper kernel first, the public surface will become inconsistent.
- Availability-gated work has to remain isolated or baseline wrappers will become cluttered and fragile.

## Review

- The earlier full-surface expansion got the package to a broad, practical wrapper/helper layer.
- The new requirement changes the target from `broad Swift Charts coverage` to `full first-party chart concept coverage`.
- The remaining work is now primarily about completeness and systematization, not about adding a few more wrappers.
