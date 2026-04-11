# Changelog

## Unreleased

### Added

- Native Swift Charts-first wrappers for bar, histogram, line, quad-curve, and range charts.
- Native helper-first construction APIs for primitive arrays, labeled values, range tuples, and shared domain presets.
- `SCNativeMultiLineChart` for native multi-series line rendering.
- `SCChartLineSeries` and `SCChartReferenceLine` shared models for multi-series charts and threshold/average overlays.
- Shared native chart models and styling types: `SCChartPoint`, `SCChartRangePoint`, `SCHistogramBin`, `SCChartSeriesStyle`, `SCChartAxesStyle`, and `SCChartDomain`.
- Additional native wrappers: `SCNativeAreaChart`, `SCNativeScatterChart`, `SCNativeGroupedBarChart`, `SCNativeStackedBarChart`, `SCNativeThresholdChart`, `SCNativeGoalChart`, and `SCComposedChart`.
- New shared models for wider static/compositional chart support: `SCChartScatterPoint`, `SCChartSectorSegment`, `SCChartBarGroup`, `SCChartStackSegment`, `SCChartBand`, `SCChartSelection`, and `SCChartViewport`.
- Availability-gated `SCNativeSectorChart` and `SCNativeDonutChart` wrappers for the Swift Charts `SectorMark` surface on newer OS versions.
- Focused tests for the extended wrapper slice, including grouped/stacked bars, scatter/sector helpers, threshold/goal wrappers, and composed chart state.
- Time-series helpers and wrappers: `SCChartTimePoint`, `SCChartVisibleDomain`, `SCChartNumericValueFormat`, `SCChartDateValueFormat`, and `SCNativeTimeSeriesChart`.
- Availability-gated interaction wrappers for selection and scrolling: `SCSelectableLineChart`, `SCSelectableBarChart`, `SCSelectableScatterChart`, `SCScrollableLineChart`, and `SCScrollableTimeSeriesChart`.
- Focused tests for the interaction/time-series slice, including formatters, viewport helpers, selection wrappers, and scrollable wrapper state.
- Public composition helper types: `SCChartAnnotation`, `SCChartOverlay`, `SCChartScale`, and `SCChartComposition`.
- Expanded composed-chart support for sector marks, shared bands, overlay-backed reference lines, point-label overlays, and helper-driven annotation placement.
- Focused tests for composition helpers, scale resolution, and overlay/band behavior.
- Public interaction helper types: `SCChartSelectionState`, `SCChartInspectionOverlay`, `SCChartScrollBehavior`, `SCChartGestureConfiguration`, and `SCChartHoverState`.
- Viewport coordination helpers for centered, clamped, and zoomed visible-window updates.
- Focused tests for the interaction-helper slice, including interaction helper state, wrapper configuration, and viewport utilities.
- Helper-style annotation presets for caption, badge, and formatted value-label rendering via `SCChartAnnotation`.
- Availability-gated `SCSelectableSectorChart` and `SCSelectableDonutChart` wrappers for `SectorMark` angle-selection workflows on newer OS versions.
- Focused tests for selectable sector/donut wrapper configuration and annotation helper presets.
- Shared hover inspection support via `SCChartHoverState`, `SCChartInspectionCallout`, and reusable hover capture overlays.
- Availability-gated `SCHoverableLineChart`, `SCHoverableBarChart`, and `SCHoverableScatterChart` wrappers for helper-style pointer inspection on newer OS versions.
- Focused tests for hover helper state and hoverable wrapper configuration.
- Availability-gated `SCSelectableTimeSeriesChart` for helper-style date-series selection on newer OS versions.
- Availability-gated inspector and crosshair presets for line, bar, scatter, and time-series charts via `SCInspector*` and `SCCrosshair*` wrappers.
- Visible-domain and scroll-behavior presets for analytics- and finance-style windows.
- Focused tests for inspection-wrapper configuration and time-series selection state.
- A new `docs/tutorials/` learning path with sequenced tutorials for first chart setup, helper-first data construction, interactions, time-series, composed charts, and legacy migration.
- Availability-gated vectorized plot wrappers: `SCNativeLinePlotChart`, `SCNativeAreaPlotChart`, `SCNativeBarPlotChart`, `SCNativePointPlotChart`, and `SCNativeRectanglePlotChart`.
- Availability-gated function and parametric plot wrappers: `SCNativeFunctionLinePlotChart`, `SCNativeParametricLinePlotChart`, and `SCNativeFunctionAreaPlotChart`.
- Availability-gated 3D wrappers and helpers: `SCChart3DPoint`, `SCChart3DPoseStyle`, `SCChart3DSeriesStyle`, `SCNative3DPointChart`, `SCNative3DRectangleChart`, `SCNative3DRuleChart`, and `SCNativeSurfacePlotChart`.
- Focused tests for vectorized plot model normalization, plot wrapper state, function plot wrapper state, and 3D helper/wrapper configuration.
- First-class axis helper state for explicit axis-mark value sources, plus legend placement helpers, foreground-style scale helpers, and richer plot-area styling.
- Native grouped and stacked area wrappers built on the shared line-series helper layer.
- Richer inspection overlay helpers with crosshair and inspector presets, including shared crosshair rendering in the hover/selection wrappers.
- Focused tests for axis/legend/foreground-style-scale/plot-style helper state and grouped/stacked area wrapper configuration.
- Legacy-to-native bridge adapters so the original `SC*Config` and `SC*Data` API remains functional during migration.
- Focused native wrapper and legacy bridge tests, including histogram binning and range normalization coverage.
- Migration guidance in the README for moving from the legacy config/data API to the native wrapper layer.

### Changed

- Added Xcode Quick Help documentation across the full exposed package API surface, including the native wrapper/helper layer and the deprecated compatibility layer, so every public type and entry point is easier to discover directly from Xcode.
- Raised minimum supported platform versions to Swift Charts baselines:
  - iOS 16+
  - macOS 13+
  - tvOS 16+
  - watchOS 9+
  - Mac Catalyst 16+
- Updated previews and sample usage to demonstrate the native API instead of the deprecated legacy API.
- Added helper-style presets on `SCChartSeriesStyle` and `SCChartAxesStyle` to make the native wrapper layer easier to adopt for common chart use cases.
- Expanded the README wrapper catalog and examples to reflect the wider native static/compositional surface, the new interaction/time-series helpers, and the remaining feature boundary after this slice.
- Expanded the README wrapper catalog and status section to include grouped/stacked area wrappers and the now-complete helper-kernel surface for axes, legends, plot styling, foreground-style scales, and crosshair/callout inspection helpers.
- Expanded the README wrapper catalog and helper examples to include selectable time-series charts, dedicated inspector/crosshair wrappers, and analytics/finance visible-window presets.
- Reworked the documentation entrypoints so README, Getting Started, and the chart-selection guide all point to the new tutorials path.
- Refactored threshold and goal wrappers to use the shared overlay/annotation composition path instead of bespoke rule-mark assembly.
- Expanded `SCChartReferenceLine` with reusable minimum/maximum helpers and default annotation labels so composed wrappers inherit the same reference-line behavior.
- Refactored selectable and scrollable wrappers to use the shared interaction helper layer while preserving compatibility overloads for direct selection bindings and `visibleDomain` entry points.
- Refactored composed-chart annotation rendering and sector-selection overlays to use the shared `SCChartAnnotationLabelView` helper path.
- Refactored selection and hover inspection rendering to share the same callout and value-label helper path.
- Reworked the documentation entrypoint around a real quick-start flow, with dedicated getting-started and chart-selection guides for new users.
- Expanded the README wrapper catalog and coverage/status sections to include the vectorized plot and 3D chart surface.

### Deprecated

- `SCManager`
- Legacy `SC*Config` and `SC*Data` convenience initializers
- Legacy `SCBarChart`, `SCHistogram`, `SCLineChart`, `SCQuadCurve`, and `SCRangeChart` initializer-based API surface

The legacy implementation remains in the package for backward compatibility and now routes through the native-first wrapper layer where applicable.
