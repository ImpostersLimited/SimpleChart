//
//  SCNativeScatterChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

/// A ready-made scatter chart backed by explicit x/y points.
public struct SCNativeScatterChart: View {
    public let points: [SCChartScatterPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?

    /// Creates a scatter chart from prebuilt scatter points.
    public init(
        points: [SCChartScatterPoint],
        seriesStyle: SCChartSeriesStyle = .scatter(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil
    ) {
        self.points = points
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain ?? .auto(values: points.map(\.y))
    }

    /// Creates a scatter chart from floating-point `(x, y)` tuples.
    public init<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        points: [(T, U)],
        labels: [String]? = nil,
        seriesStyle: SCChartSeriesStyle = .scatter(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil
    ) {
        self.init(
            points: SCChartScatterPoint.make(points: points, labels: labels),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain
        )
    }

    /// Creates a scatter chart from labeled floating-point scatter tuples.
    public init<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        labeledPoints: [(String, T, U)],
        seriesStyle: SCChartSeriesStyle = .scatter(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil
    ) {
        self.init(
            points: SCChartScatterPoint.make(labeledPoints: labeledPoints),
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(points) { point in
                PointMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
                .symbolSize(seriesStyle.markSize)
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}
