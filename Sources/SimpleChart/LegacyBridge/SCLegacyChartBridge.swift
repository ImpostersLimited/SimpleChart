//
//  SCLegacyChartBridge.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

fileprivate func scLegacyAxesStyle(
    showXAxis: Bool,
    showYAxis: Bool,
    showInterval: Bool,
    showYAxisFigure: Bool,
    xLegend: String,
    yLegend: String,
    xLegendColor: Color,
    yLegendColor: Color,
    yAxisFigureColor: Color,
    yAxisFigureFontFactor: Double,
    intervalLineWidth: CGFloat,
    intervalColor: Color,
    preferredIntervalCount: Int
) -> SCChartAxesStyle {
    SCChartAxesStyle(
        showXAxis: showXAxis,
        showYAxis: showYAxis,
        showGrid: showInterval,
        showYAxisLabels: showYAxisFigure,
        xLegend: xLegend,
        yLegend: yLegend,
        xLegendColor: xLegendColor,
        yLegendColor: yLegendColor,
        yAxisFigureColor: yAxisFigureColor,
        yAxisFigureFontFactor: yAxisFigureFontFactor,
        intervalLineWidth: intervalLineWidth,
        intervalColor: intervalColor,
        preferredIntervalCount: preferredIntervalCount
    )
}

fileprivate func scLegacySeriesStyle(
    colors: [Color],
    strokeWidth: CGFloat,
    stroke: Bool,
    showArea: Bool,
    interpolation: SCChartInterpolation,
    gradientStart: UnitPoint,
    gradientEnd: UnitPoint
) -> SCChartSeriesStyle {
    SCChartSeriesStyle(
        colors: colors,
        strokeWidth: strokeWidth,
        showArea: showArea,
        strokeOnly: stroke,
        interpolation: interpolation,
        gradientStart: gradientStart,
        gradientEnd: gradientEnd
    )
}

fileprivate func scLegacyDomain(
    lowerBound: Double,
    upperBound: Double,
    actualLowerBound: Double,
    actualUpperBound: Double
) -> SCChartDomain {
    SCChartDomain(
        lowerBound: lowerBound,
        upperBound: upperBound,
        actualLowerBound: actualLowerBound,
        actualUpperBound: actualUpperBound
    )
}

extension Array where Element == SCLineChartData {
    var scNativePoints: [SCChartPoint] {
        enumerated().map { index, point in
            SCChartPoint(id: String(index), xLabel: nil, value: point.value)
        }
    }
}

extension Array where Element == SCBarChartData {
    var scNativePoints: [SCChartPoint] {
        enumerated().map { index, point in
            SCChartPoint(id: String(index), xLabel: nil, value: point.value)
        }
    }
}

extension Array where Element == SCHistogramData {
    var scNativePoints: [SCChartPoint] {
        enumerated().map { index, point in
            SCChartPoint(id: String(index), xLabel: nil, value: point.value)
        }
    }
}

extension Array where Element == SCQuadCurveData {
    var scNativePoints: [SCChartPoint] {
        enumerated().map { index, point in
            SCChartPoint(id: String(index), xLabel: nil, value: point.value)
        }
    }
}

extension Array where Element == SCRangeChartData {
    var scNativeRangePoints: [SCChartRangePoint] {
        enumerated().map { index, point in
            let lower = Swift.min(point.lower, point.upper)
            let upper = Swift.max(point.lower, point.upper)
            return SCChartRangePoint(id: String(index), xLabel: nil, lower: lower, upper: upper)
        }
    }
}

extension SCLineChartConfig {
    var scNativeAxesStyle: SCChartAxesStyle {
        scLegacyAxesStyle(
            showXAxis: showXAxis,
            showYAxis: showYAxis,
            showInterval: showInterval,
            showYAxisFigure: showYAxisFigure,
            xLegend: xLegend,
            yLegend: yLegend,
            xLegendColor: xLegendColor,
            yLegendColor: yLegendColor,
            yAxisFigureColor: yAxisFigureColor,
            yAxisFigureFontFactor: yAxisFigureFontFactor,
            intervalLineWidth: intervalLineWidth,
            intervalColor: intervalColor,
            preferredIntervalCount: numOfInterval
        )
    }

    var scNativeSeriesStyle: SCChartSeriesStyle {
        scLegacySeriesStyle(
            colors: color,
            strokeWidth: strokeWidth,
            stroke: stroke,
            showArea: !stroke,
            interpolation: .linear,
            gradientStart: gradientStart,
            gradientEnd: gradientEnd
        )
    }

    var scNativeDomain: SCChartDomain {
        scLegacyDomain(
            lowerBound: min,
            upperBound: max,
            actualLowerBound: actualMin,
            actualUpperBound: actualMax
        )
    }
}

extension SCBarChartConfig {
    var scNativeAxesStyle: SCChartAxesStyle {
        scLegacyAxesStyle(
            showXAxis: showXAxis,
            showYAxis: showYAxis,
            showInterval: showInterval,
            showYAxisFigure: showYAxisFigure,
            xLegend: xLegend,
            yLegend: yLegend,
            xLegendColor: xLegendColor,
            yLegendColor: yLegendColor,
            yAxisFigureColor: yAxisFigureColor,
            yAxisFigureFontFactor: yAxisFigureFontFactor,
            intervalLineWidth: intervalLineWidth,
            intervalColor: intervalColor,
            preferredIntervalCount: numOfInterval
        )
    }

    var scNativeSeriesStyle: SCChartSeriesStyle {
        scLegacySeriesStyle(
            colors: color,
            strokeWidth: strokeWidth,
            stroke: stroke,
            showArea: false,
            interpolation: .linear,
            gradientStart: gradientStart,
            gradientEnd: gradientEnd
        )
    }

    var scNativeDomain: SCChartDomain {
        scLegacyDomain(
            lowerBound: min,
            upperBound: max,
            actualLowerBound: actualMin,
            actualUpperBound: actualMax
        )
    }
}

extension SCHistogramConfig {
    var scNativeAxesStyle: SCChartAxesStyle {
        scLegacyAxesStyle(
            showXAxis: showXAxis,
            showYAxis: showYAxis,
            showInterval: showInterval,
            showYAxisFigure: showYAxisFigure,
            xLegend: xLegend,
            yLegend: yLegend,
            xLegendColor: xLegendColor,
            yLegendColor: yLegendColor,
            yAxisFigureColor: yAxisFigureColor,
            yAxisFigureFontFactor: yAxisFigureFontFactor,
            intervalLineWidth: intervalLineWidth,
            intervalColor: intervalColor,
            preferredIntervalCount: numOfInterval
        )
    }

    var scNativeSeriesStyle: SCChartSeriesStyle {
        scLegacySeriesStyle(
            colors: color,
            strokeWidth: strokeWidth,
            stroke: stroke,
            showArea: false,
            interpolation: .linear,
            gradientStart: gradientStart,
            gradientEnd: gradientEnd
        )
    }

    var scNativeDomain: SCChartDomain {
        scLegacyDomain(
            lowerBound: min,
            upperBound: max,
            actualLowerBound: actualMin,
            actualUpperBound: actualMax
        )
    }
}

extension SCQuadCurveConfig {
    var scNativeAxesStyle: SCChartAxesStyle {
        scLegacyAxesStyle(
            showXAxis: showXAxis,
            showYAxis: showYAxis,
            showInterval: showInterval,
            showYAxisFigure: showYAxisFigure,
            xLegend: xLegend,
            yLegend: yLegend,
            xLegendColor: xLegendColor,
            yLegendColor: yLegendColor,
            yAxisFigureColor: yAxisFigureColor,
            yAxisFigureFontFactor: yAxisFigureFontFactor,
            intervalLineWidth: intervalLineWidth,
            intervalColor: intervalColor,
            preferredIntervalCount: numOfInterval
        )
    }

    var scNativeSeriesStyle: SCChartSeriesStyle {
        scLegacySeriesStyle(
            colors: color,
            strokeWidth: strokeWidth,
            stroke: stroke,
            showArea: !stroke,
            interpolation: .catmullRom,
            gradientStart: gradientStart,
            gradientEnd: gradientEnd
        )
    }

    var scNativeDomain: SCChartDomain {
        scLegacyDomain(
            lowerBound: min,
            upperBound: max,
            actualLowerBound: actualMin,
            actualUpperBound: actualMax
        )
    }
}

extension SCRangeChartConfig {
    var scNativeAxesStyle: SCChartAxesStyle {
        scLegacyAxesStyle(
            showXAxis: showXAxis,
            showYAxis: showYAxis,
            showInterval: showInterval,
            showYAxisFigure: showYAxisFigure,
            xLegend: xLegend,
            yLegend: yLegend,
            xLegendColor: xLegendColor,
            yLegendColor: yLegendColor,
            yAxisFigureColor: yAxisFigureColor,
            yAxisFigureFontFactor: yAxisFigureFontFactor,
            intervalLineWidth: intervalLineWidth,
            intervalColor: intervalColor,
            preferredIntervalCount: numOfInterval
        )
    }

    var scNativeSeriesStyle: SCChartSeriesStyle {
        scLegacySeriesStyle(
            colors: color,
            strokeWidth: strokeWidth,
            stroke: stroke,
            showArea: false,
            interpolation: .linear,
            gradientStart: gradientStart,
            gradientEnd: gradientEnd
        )
    }

    var scNativeDomain: SCChartDomain {
        let points = chartData.scNativeRangePoints
        return SCChartDomain.make(
            lowerValues: points.map(\.lower),
            upperValues: points.map(\.upper),
            baseZero: baseZero,
            paddingRatio: baseZero ? 0.03 : 0.08
        )
    }
}
