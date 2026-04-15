//
//  SCChartMark.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Describes the mark families that can be combined inside `SCComposedChart`.
public enum SCChartMark: Equatable {
    case line([SCChartPoint], style: SCChartSeriesStyle = .line())
    case area([SCChartPoint], style: SCChartSeriesStyle = .area())
    case bar([SCChartPoint], style: SCChartSeriesStyle = .bar())
    case point([SCChartScatterPoint], style: SCChartSeriesStyle = .scatter())
    case linePlot([SCChartPlotPoint], style: SCChartSeriesStyle = .line())
    case areaPlot(
        [SCChartPlotPoint],
        style: SCChartSeriesStyle = .area(),
        stacking: SCChartPlotStacking = .standard
    )
    case barPlot(
        [SCChartPlotPoint],
        style: SCChartSeriesStyle = .bar(),
        width: SCChartPlotDimension = .automatic,
        height: SCChartPlotDimension = .automatic,
        stacking: SCChartPlotStacking = .standard
    )
    case pointPlot([SCChartPlotPoint], style: SCChartSeriesStyle = .scatter())
    case range([SCChartRangePoint], style: SCChartSeriesStyle = .rangeFill())
    case rectangle([SCChartRectangle], style: SCChartSeriesStyle = .bar())
    case rectanglePlot(
        [SCChartPlotRectangle],
        style: SCChartSeriesStyle = .bar(),
        width: SCChartPlotDimension = .automatic,
        height: SCChartPlotDimension = .automatic
    )
    case sector([SCChartSectorSegment], style: SCChartSeriesStyle = .bar())
    case rule(SCChartReferenceLine)
}

public extension SCChartMark {
    var inferredValues: [Double] {
        switch self {
        case let .line(points, _), let .area(points, _), let .bar(points, _):
            return points.map(\.value)
        case let .point(points, _):
            return points.map(\.y)
        case let .linePlot(points, _),
             let .areaPlot(points, _, _),
             let .barPlot(points, _, _, _, _),
             let .pointPlot(points, _):
            return points.map(\.y)
        case let .range(points, _):
            return points.flatMap { [$0.lower, $0.upper] }
        case let .rectangle(rectangles, _):
            return rectangles.flatMap { [$0.yStart, $0.yEnd] }
        case let .rectanglePlot(rectangles, _, _, _):
            return rectangles.flatMap { [$0.yStart, $0.yEnd] }
        case let .sector(segments, _):
            return segments.map(\.value)
        case let .rule(referenceLine):
            return [referenceLine.value]
        }
    }
}
