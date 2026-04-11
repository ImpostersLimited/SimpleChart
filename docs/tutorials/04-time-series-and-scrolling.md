# Tutorial 4: Time-Series and Scrolling

This tutorial covers date-based charts and visible-window helpers.

## Step 1: Build Time-Series Data

```swift
let points = SCChartTimePoint.make(values: [
    (Date(timeIntervalSince1970: 1_700_000_000), 12),
    (Date(timeIntervalSince1970: 1_700_003_600), 18),
    (Date(timeIntervalSince1970: 1_700_007_200), 15)
])
```

## Step 2: Render a Time-Series Chart

```swift
SCNativeTimeSeriesChart(
    points: points,
    xAxisFormat: .monthDay,
    yAxisFormat: .currency(code: "USD")
)
```

## Step 3: Add Selection

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct SelectableTimeSeriesExample: View {
    @State private var selectionState = SCChartSelectionState()

    let points: [SCChartTimePoint]

    var body: some View {
        SCSelectableTimeSeriesChart(
            points: points,
            selectionState: $selectionState,
            inspectionOverlay: .crosshair(anchor: .top, showsCallout: true),
            xAxisFormat: .hourMinute,
            yAxisFormat: .compact
        )
    }
}
```

## Step 4: Add Scrolling

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct ScrollableTimeSeriesExample: View {
    @State private var viewport = SCChartViewport.starting(at: 0, length: 14)

    let points: [SCChartTimePoint]

    var body: some View {
        SCScrollableTimeSeriesChart(
            points: points,
            viewport: $viewport,
            visibleDomain: .analytics(points: 14),
            scrollBehavior: .analytics(points: 21),
            xAxisFormat: .monthDay
        )
    }
}
```

## Presets You Should Reuse

```swift
let analyticsWindow = SCChartVisibleDomain.analytics(points: 14)
let financeWindow = SCChartVisibleDomain.finance(tradingDays: 5)

let oneDay = SCChartScrollBehavior.timeWindow(days: 1)
let tradingWeek = SCChartScrollBehavior.finance(tradingDays: 5)
```

## Next Step

Continue to [Composed Charts and Overlays](05-composed-charts-and-overlays.md).
