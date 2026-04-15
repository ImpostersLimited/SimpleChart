# SimpleChart

SimpleChart now ships with a native Swift Charts-first API for bar, grouped bar, stacked bar, histogram, line, multi-line, area, scatter, quad-curve, threshold, goal, sector, donut, range, and composed charts. The package keeps the original `SCManager` and `SC*Config`/`SC*Data` surface for backward compatibility, but that legacy layer is deprecated and bridged onto the new wrapper views.

## Quick Start

If you are new to the package, start here instead of reading the full README top to bottom:

1. Add the package from `https://github.com/ImpostersLimited/SimpleChart.git`
2. Build your first chart with `SCNativeLineChart` or `SCNativeBarChart`
3. Use the focused guides below when you need the next step

- [Getting Started](docs/getting-started.md)
- [DocC Catalog Source](Sources/SimpleChart/SimpleChart.docc/SimpleChart.md)
- [Tutorials](docs/tutorials/README.md)
- [Chart Selection Guide](docs/chart-selection-guide.md)
- [Editor Support](docs/editor-support.md)
- [Migration from the legacy API](#migration-from-the-legacy-api)

## Platform requirements

SimpleChart now requires the first-party Swift Charts baselines:

- iOS 16+
- macOS 13+
- tvOS 16+
- watchOS 9+
- Mac Catalyst 16+

## Native-first API

The native layer is built around a small shared model surface:

- `SCChartPoint` for single-value series
- `SCChartRangePoint` for lower/upper range data
- `SCHistogramBin` for pre-binned histogram input
- `SCChartSeriesStyle` for colors, stroke width, interpolation, and fill behavior
- `SCChartAxesStyle` for legends, grid lines, and axis labels
- `SCChartDomain` for y-axis bounds
- `SCChartLineSeries` for multi-series line datasets
- `SCChartReferenceLine` for thresholds and averages
- `SCChartScatterPoint` for scatter datasets
- `SCChartSectorSegment` for sector and donut charts
- `SCChartBarGroup` and `SCChartStackSegment` for grouped and stacked bars
- `SCChartTimePoint` for time-series datasets
- `SCChartVisibleDomain`, `SCChartViewport`, and `SCChartTimeViewport` for scroll-window helpers
- `SCChartNumericValueFormat` and `SCChartDateValueFormat` for helper-style axis formatting
- `SCChartSelection` for wrapper-managed chart selection state
- `SCChartSelectionState`, `SCChartInspectionOverlay`, `SCChartScrollBehavior`, `SCChartZoomBehavior`, `SCChartGestureConfiguration`, and `SCChartHoverState` for reusable interaction configuration
- `SCChartMark` for composed mark-based chart definitions
- `SCChartAnnotationStyle`, `SCChartAnnotation`, `SCChartOverlay`, `SCChartScale`, and `SCChartComposition` for reusable composed-chart helpers

### Available native wrappers

- `SCNativeBarChart`
- `SCNativeGroupedBarChart`
- `SCNativeHistogramChart`
- `SCNativeLineChart`
- `SCNativeMultiLineChart`
- `SCNativeAreaChart`
- `SCNativeScatterChart`
- `SCNativeQuadCurveChart`
- `SCNativeThresholdChart`
- `SCNativeGoalChart`
- `SCNativeRangeChart`
- `SCNativeTimeSeriesChart`
- `SCComposedChart`
- `SCNativeSectorChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCNativeDonutChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCSelectableLineChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCSelectableBarChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCSelectableScatterChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCSelectableTimeSeriesChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCSelectableSectorChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCSelectableDonutChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCInspectorLineChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCCrosshairLineChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCInspectorBarChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCCrosshairBarChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCInspectorScatterChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCCrosshairScatterChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCInspectorTimeSeriesChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCCrosshairTimeSeriesChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCHoverableLineChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCHoverableBarChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCHoverableScatterChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCScrollableLineChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCScrollableTimeSeriesChart` (`iOS 17+`, `macOS 14+`, `tvOS 17+`, `watchOS 10+`, `Mac Catalyst 17+`)
- `SCNativeLinePlotChart` (`iOS 18+`, `macOS 15+`, `tvOS 18+`, `watchOS 11+`, `visionOS 2+`)
- `SCNativeAreaPlotChart` (`iOS 18+`, `macOS 15+`, `tvOS 18+`, `watchOS 11+`, `visionOS 2+`)
- `SCNativeBarPlotChart` (`iOS 18+`, `macOS 15+`, `tvOS 18+`, `watchOS 11+`, `visionOS 2+`)
- `SCNativePointPlotChart` (`iOS 18+`, `macOS 15+`, `tvOS 18+`, `watchOS 11+`, `visionOS 2+`)
- `SCNativeRectanglePlotChart` (`iOS 18+`, `macOS 15+`, `tvOS 18+`, `watchOS 11+`, `visionOS 2+`)
- `SCNativeFunctionLinePlotChart` (`iOS 18+`, `macOS 15+`, `tvOS 18+`, `watchOS 11+`, `visionOS 2+`)
- `SCNativeParametricLinePlotChart` (`iOS 18+`, `macOS 15+`, `tvOS 18+`, `watchOS 11+`, `visionOS 2+`)
- `SCNativeFunctionAreaPlotChart` (`iOS 18+`, `macOS 15+`, `tvOS 18+`, `watchOS 11+`, `visionOS 2+`)
- `SCNative3DPointChart` (`iOS 26+`, `macOS 26+`, `visionOS 26+`)
- `SCNative3DRectangleChart` (`iOS 26+`, `macOS 26+`, `visionOS 26+`)
- `SCNative3DRuleChart` (`iOS 26+`, `macOS 26+`, `visionOS 26+`)
- `SCNativeSurfacePlotChart` (`iOS 26+`, `macOS 26+`, `visionOS 26+`)

### Helper-first construction

The native API now supports the common cases without forcing callers to manually construct every point and domain object.

```swift
SCNativeLineChart(
    values: [12, 18, 15, 21],
    labels: ["Jan", "Feb", "Mar", "Apr"],
    seriesStyle: .area([.blue, .cyan]),
    axesStyle: .standard(x: "Month", y: "Revenue")
)

SCNativeBarChart(
    labeledValues: [("A", 3), ("B", 1), ("C", 9)],
    seriesStyle: .bar([.orange]),
    axesStyle: .minimal
)

SCNativeRangeChart(
    ranges: [(58, 92), (61, 88), (55, 95)],
    labels: ["Mon", "Tue", "Wed"],
    seriesStyle: .rangeFill([.pink]),
    axesStyle: .standard(x: "Day", y: "Range")
)

SCNativeGroupedBarChart(
    groups: [
        ("Q1", [("Revenue", 12), ("Cost", 8)]),
        ("Q2", [("Revenue", 15), ("Cost", 9)])
    ]
)

SCNativeScatterChart(
    labeledPoints: [("A", 1.5, 2.5), ("B", 3.0, 4.5)]
)
```

The helper builders are also available directly on the shared models:

```swift
let points = SCChartPoint.make(values: [2, 5, 3, 7], labels: ["Q1", "Q2", "Q3", "Q4"])
let labeledPoints = SCChartPoint.make(labeledValues: [("Jan", 12), ("Feb", 18)])
let ranges = SCChartRangePoint.make(ranges: [(58, 92), (61, 88)], labels: ["Mon", "Tue"])
let scatter = SCChartScatterPoint.make(labeledPoints: [("A", 1.5, 2.5), ("B", 3.0, 4.5)])
let segments = SCChartSectorSegment.make(segments: [("A", 40), ("B", 60)])
let groups = [
    SCChartBarGroup.make(label: "Q1", values: [("Revenue", 12), ("Cost", 8)]),
    SCChartBarGroup.make(label: "Q2", values: [("Revenue", 15), ("Cost", 9)])
]
let timeSeries = SCChartTimePoint.make(values: [
    (Date(timeIntervalSince1970: 1_700_000_000), 12),
    (Date(timeIntervalSince1970: 1_700_003_600), 18)
])

let domain = SCChartDomain.auto(points: points, baseZero: true)
let fixed = SCChartDomain.fixed(0...100)
let visibleWindow = SCChartVisibleDomain.points(7)
let analyticsWindow = SCChartVisibleDomain.analytics(points: 14)
let financeWindow = SCChartVisibleDomain.finance(tradingDays: 5)
let currencyFormat = SCChartNumericValueFormat.currency(code: "USD")
let selectionState = SCChartSelectionState()
let inspectionOverlay = SCChartInspectionOverlay.callout(anchor: .top)
let scrollBehavior = SCChartScrollBehavior.continuous(.points(7))
let timeWindow = SCChartScrollBehavior.timeWindow(hours: 24)
let analyticsScroll = SCChartScrollBehavior.analytics(points: 21)
let financeScroll = SCChartScrollBehavior.finance(tradingDays: 10)
let timeViewport = SCChartTimeViewport.starting(
    at: Date(timeIntervalSince1970: 1_700_000_000),
    duration: 60 * 60 * 24
)
let zoomBehavior = SCChartZoomBehavior(
    minimumVisibleLength: 3,
    maximumVisibleLength: 14
)
let gestures = SCChartGestureConfiguration.interactive
let compositionScale = SCChartScale(
    xVisibleDomain: .points(6),
    yDomain: SCChartScale.fixed(y: 0...100).yDomain
)
let badge = SCChartAnnotation.badge("Target", color: .blue)
let caption = SCChartAnnotation.caption("Revenue", color: .secondary)
let formatted = SCChartAnnotation.valueLabel(12.5, format: .currency(code: "USD"))
```

Common visual presets are exposed as helper factories instead of requiring every caller to assemble full style objects:

```swift
let lineStyle = SCChartSeriesStyle.line([.blue], strokeWidth: 3)
let areaStyle = SCChartSeriesStyle.area([.mint, .teal])
let barStyle = SCChartSeriesStyle.bar([.orange])
let scatterStyle = SCChartSeriesStyle.scatter([.pink], size: 60)
let minimalAxes = SCChartAxesStyle.minimal
let standardAxes = SCChartAxesStyle.standard(x: "Month", y: "Revenue")
```

### Example: line chart

```swift
import SimpleChart
import SwiftUI

struct RevenueChart: View {
    private let points = [
        SCChartPoint(id: "jan", xLabel: "Jan", value: 12),
        SCChartPoint(id: "feb", xLabel: "Feb", value: 18),
        SCChartPoint(id: "mar", xLabel: "Mar", value: 15)
    ]

    var body: some View {
        SCNativeLineChart(
            points: points,
            seriesStyle: SCChartSeriesStyle(
                colors: [.blue, .cyan],
                strokeWidth: 2,
                showArea: true,
                interpolation: .linear,
                gradientStart: .top,
                gradientEnd: .bottom
            ),
            axesStyle: SCChartAxesStyle(
                showXAxis: true,
                showYAxis: true,
                showGrid: true,
                showYAxisLabels: true,
                xLegend: "Month",
                yLegend: "Revenue"
            ),
            domain: SCChartDomain.make(values: points.map(\.value), baseZero: true)
        )
        .frame(height: 220)
    }
}
```

### Example: histogram

Use pre-binned data when you already own the bucket boundaries:

```swift
let bins = [
    SCHistogramBin(id: "0", lowerBound: 0, upperBound: 10, count: 4),
    SCHistogramBin(id: "1", lowerBound: 10, upperBound: 20, count: 7),
    SCHistogramBin(id: "2", lowerBound: 20, upperBound: 30, count: 3)
]

SCNativeHistogramChart(bins: bins)
```

Or let the wrapper bin raw values for you:

```swift
SCNativeHistogramChart(values: [3, 8, 11, 12, 14, 22, 27], binCount: 4)
```

### Example: multi-series line chart

```swift
let revenue = SCChartLineSeries.make(
    name: "Revenue",
    values: [12, 18, 15],
    labels: ["Jan", "Feb", "Mar"],
    style: .line([.blue], strokeWidth: 3)
)

let cost = SCChartLineSeries.make(
    name: "Cost",
    values: [8, 10, 9],
    labels: ["Jan", "Feb", "Mar"],
    style: .line([.orange], strokeWidth: 2)
)

let average = SCChartReferenceLine.average(of: [revenue, cost])

SCNativeMultiLineChart(
    series: [revenue, cost],
    axesStyle: .standard(x: "Month", y: "Amount"),
    referenceLines: average.map { [$0] } ?? []
)
```

Reference lines can also be created explicitly:

```swift
let target = SCChartReferenceLine.threshold(20, label: "Target", color: .red)
```

### Example: grouped, stacked, and composed charts

```swift
SCNativeGroupedBarChart(
    groups: [
        ("Q1", [("Revenue", 12), ("Cost", 8)]),
        ("Q2", [("Revenue", 15), ("Cost", 9)])
    ],
    axesStyle: .standard(x: "Quarter", y: "Amount")
)

SCNativeStackedBarChart(
    groups: [
        ("Q1", [("iPhone", 8), ("iPad", 4)]),
        ("Q2", [("iPhone", 10), ("iPad", 5)])
    ]
)

SCComposedChart(
    composition: SCChartComposition(
        marks: [
            .bar(SCChartPoint.make(labeledValues: [("Jan", 8), ("Feb", 10), ("Mar", 9)])),
            .line(SCChartPoint.make(labeledValues: [("Jan", 7), ("Feb", 11), ("Mar", 10)]))
        ],
        overlays: [
            .referenceLine(.threshold(9, label: "Target")),
            .band(SCChartBand(title: "Healthy", lower: 8, upper: 10))
        ],
        axesStyle: .standard(x: "Month", y: "Value"),
        scale: .fixed(y: 0...12),
        baseZero: true
    )
)
```

The composition helpers can also be reused directly when you want a mark-level API without dropping down to raw Swift Charts:

```swift
let composedPoints = SCChartPoint.make(values: [3, 6, 5], labels: ["A", "B", "C"])
let composition = SCChartComposition(
    marks: [
        .line(composedPoints),
        .sector(SCChartSectorSegment.make(segments: [("North", 40), ("South", 60)]))
    ],
    overlays: [
        .referenceLines([
            SCChartReferenceLine.average(of: composedPoints)!,
            SCChartReferenceLine.maximum(of: composedPoints)!
        ]),
        .pointLabels(points: composedPoints, color: .secondary, anchor: .top)
    ]
)

SCComposedChart(composition: composition)
```

### Example: time-series, selection, hover inspection, and scrolling

```swift
let history = SCChartTimePoint.make(values: [
    (Date(timeIntervalSince1970: 1_700_000_000), 12),
    (Date(timeIntervalSince1970: 1_700_003_600), 18),
    (Date(timeIntervalSince1970: 1_700_007_200), 15)
])

SCNativeTimeSeriesChart(
    points: history,
    xAxisFormat: .hourMinute,
    yAxisFormat: .currency(code: "USD"),
    referenceLines: [.threshold(16, label: "Target")]
)
```

Availability-gated interactive wrappers are exposed on newer Swift Charts OS levels:

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct RevenueExplorer: View {
    @State private var selectionState = SCChartSelectionState()
    @State private var hoverState: SCChartHoverState?
    @State private var viewport = SCChartViewport.starting(at: 0, length: 7)
    @State private var timeViewport = SCChartTimeViewport.starting(
        at: Date(timeIntervalSince1970: 1_700_000_000),
        duration: 7_200
    )

    let points = SCChartPoint.make(
        labeledValues: [("Mon", 12), ("Tue", 18), ("Wed", 15), ("Thu", 20)]
    )
    let history = SCChartTimePoint.make(values: [
        (Date(timeIntervalSince1970: 1_700_000_000), 12),
        (Date(timeIntervalSince1970: 1_700_003_600), 18),
        (Date(timeIntervalSince1970: 1_700_007_200), 15)
    ])

    var body: some View {
        VStack {
            SCSelectableLineChart(
                points: points,
                selectionState: $selectionState,
                inspectionOverlay: .callout(anchor: .bottom),
                gestureConfiguration: .selectionOnly
            )

            SCSelectableDonutChart(
                segments: SCChartSectorSegment.make(segments: [("Free", 12), ("Paid", 5)]),
                selectionState: $selectionState,
                inspectionOverlay: .pointLabel(anchor: .top),
                gestureConfiguration: .interactive
            )

            SCHoverableBarChart(
                points: points,
                hoverState: $hoverState,
                inspectionOverlay: .callout(anchor: .top),
                yAxisFormat: .compact
            )

            SCScrollableLineChart(
                points: points,
                viewport: $viewport,
                scrollBehavior: .continuous(.points(3)),
                zoomBehavior: .init(minimumVisibleLength: 2, maximumVisibleLength: 7),
                gestureConfiguration: .interactive,
                yAxisFormat: .number(precision: 0)
            )

            SCScrollableTimeSeriesChart(
                points: history,
                viewport: $timeViewport,
                scrollBehavior: .timeWindow(seconds: 7_200),
                zoomBehavior: .init(minimumVisibleLength: 1_800, maximumVisibleLength: 14_400),
                xAxisFormat: .hourMinute,
                gestureConfiguration: .scrollOnly,
                yAxisFormat: .compact
            )
        }
    }
}
```

`SCChartAnnotation` now exposes helper-style presets that match the composed and interactive wrapper behavior:

```swift
let callout = SCChartAnnotation.callout("Average", color: .primary)
let badge = SCChartAnnotation.badge("Goal", color: .green)
let caption = SCChartAnnotation.caption("Revenue", color: .secondary)
let value = SCChartAnnotation.valueLabel(42, format: .number(precision: 0))
```

### Example: range chart

```swift
let points = [
    SCChartRangePoint(id: "mon", xLabel: "Mon", lower: 58, upper: 92),
    SCChartRangePoint(id: "tue", xLabel: "Tue", lower: 61, upper: 88),
    SCChartRangePoint(id: "wed", xLabel: "Wed", lower: 55, upper: 95)
]

SCNativeRangeChart(
    points: points,
    seriesStyle: SCChartSeriesStyle(colors: [.pink], strokeWidth: 2, strokeOnly: false),
    axesStyle: SCChartAxesStyle(showXAxis: true, showYAxis: true, showGrid: true),
    domain: SCChartDomain.make(
        lowerValues: points.map(\.lower),
        upperValues: points.map(\.upper),
        paddingRatio: 0.08
    )
)
```

## Legacy compatibility layer

The original API remains available for transition purposes:

- `SCBarChart`, `SCHistogram`, `SCLineChart`, `SCQuadCurve`, `SCRangeChart`
- `SCManager`
- `SC*Config` and `SC*Data` types

Those types are deprecated and internally bridged onto the native wrapper layer. Existing call sites should continue to build, but new code should move to the native API above.

### Legacy example

```swift
let data = SCManager.getLineChartData([2, 5, 3, 7])
let config = SCLineChartConfig(chartData: data, showInterval: true, showYAxisFigure: true)
SCLineChart(config: config)
```

That still works, but it now emits deprecation warnings and should be treated as migration-only code.

## Migration guide

The native layer is intended to replace the legacy `SCManager` + `SC*Config` + `SC*Data` composition pattern. The mapping is straightforward:

- `SCBarChartData`, `SCLineChartData`, and `SCQuadCurveData` -> `SCChartPoint`
- `SCRangeChartData` -> `SCChartRangePoint`
- `SCHistogramData` -> raw `[Double]` input or explicit `[SCHistogramBin]`
- `SCBarChart`, `SCLineChart`, `SCQuadCurve`, `SCRangeChart`, `SCHistogram` -> corresponding `SCNative*` wrapper
- `SC*Config` visual settings -> `SCChartSeriesStyle`, `SCChartAxesStyle`, and `SCChartDomain`

### Legacy line chart -> native line chart

```swift
// Legacy
let legacyData = SCManager.getLineChartData([2, 5, 3, 7])
let legacyConfig = SCLineChartConfig(
    chartData: legacyData,
    showInterval: true,
    showYAxisFigure: true,
    legendTitle: "Revenue",
    xLegend: "Month",
    yLegend: "Value"
)

SCLineChart(config: legacyConfig)

// Native
let points = [
    SCChartPoint(id: "0", xLabel: "0", value: 2),
    SCChartPoint(id: "1", xLabel: "1", value: 5),
    SCChartPoint(id: "2", xLabel: "2", value: 3),
    SCChartPoint(id: "3", xLabel: "3", value: 7)
]

SCNativeLineChart(
    points: points,
    seriesStyle: SCChartSeriesStyle(showArea: true),
    axesStyle: SCChartAxesStyle(
        showXAxis: true,
        showYAxis: true,
        showGrid: true,
        showYAxisLabels: true,
        legendTitle: "Revenue",
        xLegend: "Month",
        yLegend: "Value"
    ),
    domain: SCChartDomain.make(values: points.map(\.value), baseZero: true)
)
```

### Legacy property mapping

- Legacy `stroke == true` maps to `SCChartSeriesStyle.strokeOnly == true`
- Legacy filled line/curve charts map to `SCChartSeriesStyle.showArea == true`
- Legacy `showInterval` maps to `SCChartAxesStyle.showGrid`
- Legacy axis figure/label visibility maps to `SCChartAxesStyle.showXAxis`, `showYAxis`, and `showYAxisLabels`
- Legacy range data with reversed lower/upper bounds is normalized during bridging, but native `SCChartRangePoint` should be created with the intended semantic lower and upper values directly

### Recommended migration order

1. Replace `SCManager.get*ChartData(...)` helpers with direct `SCChartPoint` / `SCChartRangePoint` / `SCHistogramBin` construction.
2. Replace `SC*Config` usage with `SCChartSeriesStyle`, `SCChartAxesStyle`, and `SCChartDomain`.
3. Swap `SC*Chart` legacy views for the matching `SCNative*` wrapper.
4. Remove remaining deprecated imports or preview/demo usage once downstream call sites are migrated.

## Charts covered

SimpleChart includes native wrappers for:

1. Bar charts
2. Grouped bar charts
3. Stacked bar charts
4. Histograms
5. Line charts
6. Multi-line charts
7. Area charts
8. Grouped area charts
9. Stacked area charts
10. Scatter charts
11. Quad-curve charts
12. Threshold and goal charts
13. Range charts
14. Sector and donut charts on newer supported OS versions
15. Composed mark-based charts
16. Time-series line charts
17. Availability-gated selectable line, bar, scatter, time-series, sector, and donut charts
18. Availability-gated inspector and crosshair wrappers for line, bar, scatter, and time-series charts
19. Availability-gated hoverable line, bar, and scatter charts
20. Availability-gated scrollable line and time-series charts
21. Availability-gated vectorized line, area, bar, point, and rectangle plot wrappers
22. Availability-gated function and parametric plot wrappers
23. Availability-gated 3D point, rectangle, rule, and surface plot wrappers

## Status

Current implementation includes the native wrapper layer, the compatibility bridge, a native-first sample surface, and bridge-focused plus wrapper-state tests. The next migration step for downstream users is to replace legacy `SC*Data` and `SC*Config` construction with `SCChartPoint`, `SCChartRangePoint`, `SCHistogramBin`, and the native wrapper views directly.

The package intentionally still does not expose every single first-party Swift Charts feature yet. It now covers a substantially wider static/compositional surface:

- single-series bar, histogram, line, area, scatter, quad-curve, threshold, goal, and range charts
- grouped and stacked bars
- grouped and stacked area charts
- sector and donut charts on newer OS versions
- multi-series line charts
- average and threshold reference lines
- composed mark-based charts with line, area, point, bar, range, sector, and rule marks
- composition helpers for overlays, annotations, scales, foreground-style scales, legends, plot styling, and shared chart composition objects
- time-series wrappers with helper date/value formatting
- availability-gated selection wrappers for line, bar, scatter, time-series, sector, and donut charts
- availability-gated inspector and crosshair wrappers for line, bar, scatter, and time-series charts
- availability-gated hover inspection wrappers for line, bar, and scatter charts
- availability-gated scrolling helpers and visible-domain wrappers for indexed and time-series charts
- availability-gated vectorized plot wrappers for point, line, area, bar, and rectangle plot surfaces
- availability-gated function, band-function, and parametric plot wrappers
- availability-gated 3D chart wrappers and helper models for point, rectangle, rule, and surface plots
- public interaction helpers for selection state, hover state, inspection overlays, crosshair/callout inspector presets, scroll behavior, gesture configuration, and viewport zoom/clamp utilities
- helper builders for primitive arrays, labeled values, grouped values, scatter points, and sector segments
- helper builders and normalized models for vectorized plot points, spans, ranges, rectangles, and 3D points
- helper presets for domains, axes, axis mark value sources, styles, legends, visible domains, visible-window presets for analytics/finance use cases, scroll behavior, plot styling, and axis value formatting

The previously documented helper-kernel gaps around grouped/stacked area variants, richer crosshair/callout inspection presets, and first-class axis/legend/plot/foreground-style helpers are now covered by the native API surface.
