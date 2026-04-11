# Tutorial 1: Your First Chart

This tutorial gets you from package import to a visible chart with the smallest possible API surface.

## Goal

Build a line chart from raw values and labels.

## Starting Point

```swift
import SimpleChart
import SwiftUI
```

## Step 1: Add a Chart View

```swift
struct RevenueChart: View {
    var body: some View {
        SCNativeLineChart(
            values: [12, 18, 15, 21],
            labels: ["Jan", "Feb", "Mar", "Apr"]
        )
        .frame(height: 220)
        .padding()
    }
}
```

## What Happened

- `values` were converted into `SCChartPoint` values automatically
- `labels` became the x-axis labels
- the wrapper computed a reasonable y-domain for you
- the default `SCChartSeriesStyle.line()` preset was applied automatically

## Step 2: Make It Look Intentional

```swift
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

## Try Another Wrapper

If your data is category comparison instead of a trend, switch to:

```swift
SCNativeBarChart(
    labeledValues: [("Free", 120), ("Pro", 45), ("Team", 12)],
    seriesStyle: .bar([.orange]),
    axesStyle: .standard(x: "Plan", y: "Users")
)
```

## Next Step

Continue to [Working with the Helper-First API](02-helper-first-api.md).
