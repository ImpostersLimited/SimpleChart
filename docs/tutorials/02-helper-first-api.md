# Tutorial 2: Working with the Helper-First API

The wrappers are convenient, but most non-trivial usage gets better when you construct reusable shared models once and pass them into multiple charts.

## Goal

Build reusable chart inputs with the helper layer.

## Step 1: Create Shared Data

```swift
let points = SCChartPoint.make(
    labeledValues: [("Jan", 12), ("Feb", 18), ("Mar", 15), ("Apr", 21)]
)

let domain = SCChartDomain.auto(points: points, baseZero: true)
let style = SCChartSeriesStyle.area([.blue, .cyan], strokeWidth: 3)
let axes = SCChartAxesStyle.standard(x: "Month", y: "Revenue")
```

## Step 2: Pass the Shared Models into a Wrapper

```swift
SCNativeLineChart(
    points: points,
    seriesStyle: style,
    axesStyle: axes,
    domain: domain
)
```

## Why This Matters

This pattern is better when:

- you want to reuse the same dataset across multiple chart types
- you want explicit control over the domain
- you want consistent styling across a dashboard
- you want to move gradually toward `SCComposedChart`

## More Shared Builders

```swift
let ranges = SCChartRangePoint.make(
    ranges: [(58, 92), (61, 88), (55, 95)],
    labels: ["Mon", "Tue", "Wed"]
)

let grouped = [
    SCChartBarGroup.make(label: "Q1", values: [("Revenue", 12), ("Cost", 8)]),
    SCChartBarGroup.make(label: "Q2", values: [("Revenue", 15), ("Cost", 9)])
]

let scatter = SCChartScatterPoint.make(
    labeledPoints: [("A", 1.5, 2.5), ("B", 3.0, 4.5)]
)
```

## Shared Presets Worth Knowing

```swift
let visibleWindow = SCChartVisibleDomain.analytics(points: 14)
let financeWindow = SCChartVisibleDomain.finance(tradingDays: 5)

let compactNumbers = SCChartNumericValueFormat.compact
let currency = SCChartNumericValueFormat.currency(code: "USD")
```

## Next Step

Continue to [Selections, Hover, and Crosshair](03-selections-hover-and-crosshair.md).
