# Chart Selection Guide

Use this guide when you know the data you want to show, but not which SimpleChart wrapper matches it best.

If you want a step-by-step learning path instead of a chooser, start with the [Tutorials](tutorials/README.md).

## Choose by Goal

| Goal | Recommended wrapper | Notes |
| --- | --- | --- |
| Show a simple trend over categories | `SCNativeLineChart` | Good default for most dashboards and summaries |
| Show multiple trend lines together | `SCNativeMultiLineChart` | Use when each series shares the same x labels |
| Show a trend over time | `SCNativeTimeSeriesChart` | Use with `SCChartTimePoint` and date formatting helpers |
| Compare category totals | `SCNativeBarChart` | Best default for direct category comparison |
| Compare grouped categories | `SCNativeGroupedBarChart` | Use when each x group contains multiple peers |
| Show composition within each category | `SCNativeStackedBarChart` | Best when totals plus part-to-whole matter |
| Show lower and upper bounds | `SCNativeRangeChart` | Good for min/max, confidence ranges, or daily spans |
| Show a distribution | `SCNativeHistogramChart` | Use raw values or pre-binned `SCHistogramBin` data |
| Show x/y relationships | `SCNativeScatterChart` | Best when x is numeric instead of categorical |
| Show part-to-whole | `SCNativeSectorChart` or `SCNativeDonutChart` | Requires the newer OS availability for `SectorMark` |
| Show thresholds or targets | `SCNativeThresholdChart` or `SCNativeGoalChart` | Good for KPI dashboards |
| Mix several chart marks together | `SCComposedChart` | Use when no single ready-made wrapper matches the view |

## Choose by Data Shape

### You have `[Double]` values

Use:

- `SCNativeLineChart(values:labels:)`
- `SCNativeBarChart(values:labels:)`
- `SCNativeHistogramChart(values:binCount:)`

### You have labeled values like `[("Jan", 12)]`

Use:

- `SCNativeLineChart(labeledValues:)`
- `SCNativeBarChart(labeledValues:)`
- `SCChartPoint.make(labeledValues:)` if you want to reuse the points

### You have lower/upper pairs like `[(58, 92)]`

Use:

- `SCNativeRangeChart(ranges:labels:)`
- `SCChartRangePoint.make(ranges:labels:)` if you want reusable models

### You have `(x, y)` numeric pairs

Use:

- `SCNativeScatterChart`
- `SCChartScatterPoint.make(labeledPoints:)`

### You have time-based points

Use:

- `SCNativeTimeSeriesChart`
- `SCChartTimePoint.make(values:)`

### You have grouped values inside each x-axis bucket

Use:

- `SCNativeGroupedBarChart`
- `SCNativeStackedBarChart`
- `SCChartBarGroup.make(...)`

### You need pie or donut segments

Use:

- `SCNativeSectorChart`
- `SCNativeDonutChart`
- `SCChartSectorSegment.make(segments:)`

## Choose by Interaction

These wrappers are availability-gated to the newer OS levels supported by Swift Charts interaction APIs.

| Interaction need | Wrapper |
| --- | --- |
| Tap/select line values | `SCSelectableLineChart` |
| Tap/select bar values | `SCSelectableBarChart` |
| Tap/select scatter values | `SCSelectableScatterChart` |
| Tap/select sector or donut segments | `SCSelectableSectorChart`, `SCSelectableDonutChart` |
| Hover to inspect line values | `SCHoverableLineChart` |
| Hover to inspect bar values | `SCHoverableBarChart` |
| Hover to inspect scatter values | `SCHoverableScatterChart` |
| Scroll or zoom an indexed line chart | `SCScrollableLineChart` |
| Scroll or zoom a time-series chart | `SCScrollableTimeSeriesChart` |

Shared helper types:

- `SCChartSelectionState`
- `SCChartHoverState`
- `SCChartInspectionOverlay`
- `SCChartScrollBehavior`
- `SCChartZoomBehavior`
- `SCChartGestureConfiguration`
- `SCChartViewport`
- `SCChartTimeViewport`

## When to Use `SCComposedChart`

Use `SCComposedChart` when you need any of these:

- bars plus a line in the same chart
- overlays like threshold bands and reference lines
- annotations driven by the helper layer
- a single chart that mixes different mark types
- a custom view that would otherwise force you to drop directly to raw Swift Charts code

If your chart is only one family and already has a dedicated wrapper, prefer the dedicated wrapper first.

## Sensible Defaults

If you are still unsure, start with these:

- dashboard trend: `SCNativeLineChart`
- category comparison: `SCNativeBarChart`
- KPI target tracking: `SCNativeGoalChart`
- uncertain range or spread: `SCNativeRangeChart`
- mixed analytics card: `SCComposedChart`

## Next Step

If you have not installed the package or built your first chart yet, go back to [Getting Started](getting-started.md). If you want guided examples after that, continue with the [Tutorials](tutorials/README.md).
