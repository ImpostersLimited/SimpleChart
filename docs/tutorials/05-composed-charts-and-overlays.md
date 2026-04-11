# Tutorial 5: Composed Charts and Overlays

Use `SCComposedChart` when a dedicated wrapper is not enough.

## Goal

Build a chart that combines a line, an area fill, and a threshold reference line.

## Step 1: Create Shared Data

```swift
let revenue = SCChartPoint.make(
    labeledValues: [("Jan", 12), ("Feb", 18), ("Mar", 15), ("Apr", 21)]
)
```

## Step 2: Describe the Marks

```swift
let marks: [SCChartMark] = [
    .area(points: revenue, style: .area([.blue, .cyan])),
    .line(points: revenue, style: .line([.blue], strokeWidth: 3))
]
```

## Step 3: Add Overlays and Annotations

```swift
let overlays: [SCChartOverlay] = [
    .referenceLine(
        SCChartReferenceLine.threshold(
            value: 16,
            title: "Target",
            color: .red
        )
    )
]

let annotations: [SCChartAnnotation] = [
    .badge("Revenue", color: .blue)
]
```

## Step 4: Build the Composed Chart

```swift
SCComposedChart(
    composition: SCChartComposition(
        marks: marks,
        overlays: overlays,
        annotations: annotations,
        scale: SCChartScale.fixed(y: 0...24)
    ),
    axesStyle: .standard(x: "Month", y: "Revenue")
)
```

## When to Reach for `SCComposedChart`

Use it when you need:

- bars plus a line in the same chart
- threshold bands or multiple reference lines
- helper-driven annotations
- mixed mark types that do not have a dedicated wrapper

If one dedicated wrapper already fits your chart, prefer that first.

## Next Step

Continue to [Migrating from the Legacy API](06-migrating-from-legacy-api.md).
