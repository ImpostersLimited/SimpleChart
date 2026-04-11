# Tutorial 3: Selections, Hover, and Crosshair

This tutorial covers the ready-made interaction wrappers for the most common inspection patterns.

## Requirements

These wrappers require the newer interaction-capable OS levels:

- iOS 17+
- macOS 14+
- tvOS 17+
- watchOS 10+
- Mac Catalyst 17+

## Selection

Use selection wrappers when you want tap or click inspection that updates your own state.

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct SelectableRevenueChart: View {
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

## Inspector Wrappers

Use the dedicated inspector wrappers when you want a ready-made callout pattern without configuring the overlay yourself.

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct InspectorExample: View {
    @State private var selection: SCChartSelection?

    private let points = SCChartPoint.make(
        labeledValues: [("Mon", 12), ("Tue", 18), ("Wed", 15)]
    )

    var body: some View {
        SCInspectorBarChart(
            points: points,
            selection: $selection,
            yAxisFormat: .compact
        )
    }
}
```

## Crosshair Wrappers

Use the crosshair wrappers when you want the selected point plus guide rules through the plot area.

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct CrosshairExample: View {
    @State private var selection: SCChartSelection?

    private let points = SCChartPoint.make(
        labeledValues: [("Mon", 12), ("Tue", 18), ("Wed", 15)]
    )

    var body: some View {
        SCCrosshairLineChart(
            points: points,
            selection: $selection,
            showsCallout: true
        )
    }
}
```

## Hover Inspection

Use hover wrappers for pointer-based inspection.

```swift
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct HoverExample: View {
    @State private var hoverState: SCChartHoverState?

    private let points = SCChartPoint.make(
        labeledValues: [("Mon", 12), ("Tue", 18), ("Wed", 15)]
    )

    var body: some View {
        SCHoverableScatterChart(
            points: SCChartScatterPoint.make(
                labeledPoints: [("A", 1.5, 2.5), ("B", 3.0, 4.5)]
            ),
            hoverState: $hoverState,
            inspectionOverlay: .inspector(anchor: .top)
        )
    }
}
```

## Next Step

Continue to [Time-Series and Scrolling](04-time-series-and-scrolling.md).
