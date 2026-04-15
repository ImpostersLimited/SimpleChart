# Interactive Charts

SimpleChart keeps interactive chart state in public helper types so you can drive selection, scrolling, and zoom from SwiftUI state instead of dropping down to raw Swift Charts APIs.

## Selection and Inspection

Use the selectable and hoverable wrappers when you want chart gestures without rebuilding the interaction layer yourself.

The main pieces are:

- ``SCChartSelectionState`` for externalized selection state
- ``SCChartInspectionOverlay`` for point-label, callout, crosshair, and inspector presentation
- ``SCChartGestureConfiguration`` for enabling or disabling selection, scrolling, and zooming

Examples:

- ``SCSelectableLineChart``
- ``SCSelectableBarChart``
- ``SCHoverableLineChart``
- ``SCInspectorTimeSeriesChart``

## Scroll and Zoom

Use visible-window helpers when the chart should be navigable over time or across a large indexed series.

- ``SCChartScrollBehavior`` describes the default visible window.
- ``SCChartViewport`` stores an indexed x-domain window.
- ``SCChartTimeViewport`` stores a date-based x-domain window.
- ``SCChartZoomBehavior`` constrains how far the chart may zoom in or out.

For simple scrolling only, a `Date` binding is enough:

```swift
SCScrollableTimeSeriesChart(
    points: history,
    scrollPosition: $scrollPosition,
    scrollBehavior: .timeWindow(hours: 24)
)
```

For viewport-driven zoom and programmatic navigation, bind the whole window:

```swift
SCScrollableTimeSeriesChart(
    points: history,
    viewport: $viewport,
    scrollBehavior: .timeWindow(hours: 24),
    zoomBehavior: .init(
        minimumVisibleLength: 60 * 60,
        maximumVisibleLength: 60 * 60 * 24 * 7
    )
)
```

The same mental model applies to ``SCScrollableLineChart`` for indexed data.
