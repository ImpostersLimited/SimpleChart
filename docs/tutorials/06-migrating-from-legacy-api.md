# Tutorial 6: Migrating from the Legacy API

The package still ships the legacy `SCManager` and `SC*Config` / `SC*Data` surface for backward compatibility, but it is deprecated. This tutorial shows the practical replacement path.

## Old Pattern

```swift
let points = [
    SCLine(pointValue: 12, interval: .labeled("Jan")),
    SCLine(pointValue: 18, interval: .labeled("Feb"))
]

let data = SCLineChartData(dataPoints: points)
let config = SCLineChartConfig()

SCLineChart(chartData: data, chartConfig: config)
```

## New Pattern

```swift
let points = SCChartPoint.make(
    labeledValues: [("Jan", 12), ("Feb", 18)]
)

SCNativeLineChart(
    points: points,
    seriesStyle: .line(),
    axesStyle: .standard()
)
```

## Mapping Guide

| Legacy surface | Native replacement |
| --- | --- |
| `SCManager` helpers | `SCChartPoint.make`, `SCChartRangePoint.make`, `SCChartBarGroup.make`, shared helper models |
| `SCLineChart` | `SCNativeLineChart` |
| `SCBarChart` | `SCNativeBarChart` |
| `SCHistogram` | `SCNativeHistogramChart` |
| `SCQuadCurve` | `SCNativeQuadCurveChart` |
| `SCRangeChart` | `SCNativeRangeChart` |
| `SC*Config` | `SCChartSeriesStyle`, `SCChartAxesStyle`, `SCChartDomain`, interaction helpers |
| `SC*Data` | shared model arrays such as `SCChartPoint`, `SCChartRangePoint`, `SCChartTimePoint`, `SCChartBarGroup` |

## Recommended Migration Order

1. Replace legacy data builders with the shared helper models.
2. Swap the legacy chart view for the native wrapper equivalent.
3. Move styling into `SCChartSeriesStyle`, `SCChartAxesStyle`, and `SCChartDomain`.
4. If the chart is interaction-heavy, replace any custom inspection logic with the built-in selectable, inspector, crosshair, hoverable, or scrollable wrappers.

## When to Keep the Legacy API

Only keep it temporarily when:

- you are migrating a large codebase in stages
- you want backward compatibility while downstream modules update

For new code, use the native wrapper layer directly.

## Next Step

Go back to the [tutorial index](README.md) or the package [README](../../README.md).
