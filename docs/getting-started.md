# Getting Started with SimpleChart

This guide is the shortest path from adding the package to rendering your first chart.

If you already know which chart you need, use the [Chart Selection Guide](chart-selection-guide.md). If you are migrating existing `SCManager` or `SC*Config` code, jump to the migration section in the [README](../README.md#migration-from-the-legacy-api).

If you prefer a guided sequence instead of a reference-style guide, use the [Tutorials](tutorials/README.md).

## Requirements

SimpleChart uses the first-party Swift Charts baselines:

- iOS 16+
- macOS 13+
- tvOS 16+
- watchOS 9+
- Mac Catalyst 16+

Some interaction wrappers require newer OS versions:

- iOS 17+
- macOS 14+
- tvOS 17+
- watchOS 10+
- Mac Catalyst 17+

## Install

### Xcode

1. Open your project settings.
2. Go to `Package Dependencies`.
3. Add `https://github.com/ImpostersLimited/SimpleChart.git`.
4. Link the `SimpleChart` product to your target.

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/ImpostersLimited/SimpleChart.git", branch: "main")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "SimpleChart", package: "SimpleChart")
        ]
    )
]
```

Then import the package:

```swift
import SimpleChart
import SwiftUI
```

## Mental Model

Most native wrappers use the same four concepts:

- `SCChartPoint`: one plotted value with an x-axis label
- `SCChartSeriesStyle`: colors, stroke, fill, interpolation, and symbol sizing
- `SCChartAxesStyle`: legends, grid visibility, and axis labels
- `SCChartDomain`: optional y-axis bounds

If you do not want to construct those objects manually, the package already includes helper-first builders and convenience initializers.

## First Chart

Start with the helper-first line chart API:

```swift
import SimpleChart
import SwiftUI

struct RevenueChart: View {
    var body: some View {
        SCNativeLineChart(
            values: [12, 18, 15, 21],
            labels: ["Jan", "Feb", "Mar", "Apr"],
            seriesStyle: .area([.blue, .cyan]),
            axesStyle: .standard(x: "Month", y: "Revenue")
        )
        .frame(height: 220)
        .padding()
    }
}
```

This is enough for most first-use cases:

- values become `SCChartPoint` instances automatically
- labels become the x-axis labels
- the wrapper computes a reasonable y-domain for you
- the style preset gives you a line with an area fill

## First Bar Chart

Use labeled values when you want category comparison:

```swift
SCNativeBarChart(
    labeledValues: [("Free", 120), ("Pro", 45), ("Team", 12)],
    seriesStyle: .bar([.orange]),
    axesStyle: .standard(x: "Plan", y: "Users")
)
```

## First Range Chart

Use range charts when each x-value has a lower and upper bound:

```swift
SCNativeRangeChart(
    ranges: [(58, 92), (61, 88), (55, 95)],
    labels: ["Mon", "Tue", "Wed"],
    seriesStyle: .rangeFill([.pink]),
    axesStyle: .standard(x: "Day", y: "Range")
)
```

## Common Helpers

If you want to construct data once and reuse it across multiple wrappers:

```swift
let points = SCChartPoint.make(
    labeledValues: [("Jan", 12), ("Feb", 18), ("Mar", 15)]
)

let domain = SCChartDomain.auto(points: points, baseZero: true)
let style = SCChartSeriesStyle.line([.blue], strokeWidth: 3)
let axes = SCChartAxesStyle.standard(x: "Month", y: "Revenue")
```

Then pass them directly:

```swift
SCNativeLineChart(
    points: points,
    seriesStyle: style,
    axesStyle: axes,
    domain: domain
)
```

## Interaction Wrappers

On newer OS versions, the package exposes ready-made wrappers for selection, hover inspection, and scrolling.

### Selection

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct SelectableExample: View {
    @State private var selectionState = SCChartSelectionState()

    private let points = SCChartPoint.make(
        labeledValues: [("Mon", 12), ("Tue", 18), ("Wed", 15)]
    )

    var body: some View {
        SCSelectableLineChart(
            points: points,
            selectionState: $selectionState,
            inspectionOverlay: .callout(anchor: .bottom)
        )
    }
}
```

### Hover inspection

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct HoverExample: View {
    @State private var hoverState: SCChartHoverState?

    private let points = SCChartPoint.make(
        labeledValues: [("Mon", 12), ("Tue", 18), ("Wed", 15)]
    )

    var body: some View {
        SCHoverableBarChart(
            points: points,
            hoverState: $hoverState,
            inspectionOverlay: .callout(anchor: .top),
            yAxisFormat: .compact
        )
    }
}
```

### Scrolling

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct ScrollableExample: View {
    @State private var viewport = SCChartViewport.starting(at: 0, length: 7)

    private let points = SCChartPoint.make(values: [12, 18, 15, 20, 21, 19, 17, 23, 24])

    var body: some View {
        SCScrollableLineChart(
            points: points,
            viewport: $viewport,
            scrollBehavior: .continuous(.points(4))
        )
    }
}
```

## Which Wrapper Should I Use?

Use this quick mapping:

- trend over categories: `SCNativeLineChart`
- trend over dates: `SCNativeTimeSeriesChart`
- compare categories: `SCNativeBarChart`
- compare grouped categories: `SCNativeGroupedBarChart`
- compare composition within a category: `SCNativeStackedBarChart`
- show lower/upper bounds: `SCNativeRangeChart`
- show distribution: `SCNativeHistogramChart`
- show x/y pairs: `SCNativeScatterChart`
- show part-to-whole on newer OS versions: `SCNativeSectorChart` or `SCNativeDonutChart`
- combine multiple mark types: `SCComposedChart`

For a fuller chooser, use the [Chart Selection Guide](chart-selection-guide.md).

## What to Read Next

- [Tutorials](tutorials/README.md)
- [Chart Selection Guide](chart-selection-guide.md)
- [README](../README.md) for the full API surface and migration notes
