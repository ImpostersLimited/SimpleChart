# Getting Started

Build your first chart with a wrapper first, then drop down into helper types only when you need more control.

## Create a First Chart

Most first-use cases can start with a native wrapper plus a style preset:

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
    }
}
```

This wrapper path automatically builds ``SCChartPoint`` values, derives a reasonable ``SCChartDomain``, and applies the shared style helpers.

## Learn the Core Building Blocks

When you need more control, the key helper types are:

- ``SCChartPoint`` for categorical values
- ``SCChartTimePoint`` for date-based series
- ``SCChartSeriesStyle`` for fill, stroke, interpolation, and symbol sizing
- ``SCChartAxesStyle`` for titles, grid lines, and legend behavior
- ``SCChartDomain`` for explicit y-axis ranges

## Next Steps

- Read <doc:WrapperChooser> to pick the right wrapper family.
- Read <doc:InteractiveCharts> when you need selection, hover, scroll, or zoom.
- Use the repository guides in `docs/` for longer walkthroughs and copy-paste examples.
