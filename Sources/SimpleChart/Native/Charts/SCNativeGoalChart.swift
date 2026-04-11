//
//  SCNativeGoalChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// A composed chart that overlays goal reference lines on top of bar values.
public struct SCNativeGoalChart: View {
    public let points: [SCChartPoint]
    public let goal: SCChartReferenceLine
    public let caution: SCChartReferenceLine?
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?

    /// Creates a goal chart from prebuilt categorical points and goal lines.
    public init(
        points: [SCChartPoint],
        goal: SCChartReferenceLine,
        caution: SCChartReferenceLine? = nil,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil
    ) {
        self.points = points
        self.goal = goal
        self.caution = caution
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        let referenceValues = [goal.value] + (caution.map { [$0.value] } ?? [])
        self.domain = domain ?? .auto(values: points.map(\.value) + referenceValues, baseZero: true)
    }

    /// Creates a goal chart from floating-point values, optional labels, and goal lines.
    public init<T: BinaryFloatingPoint>(
        values: [T],
        labels: [String]? = nil,
        goal: SCChartReferenceLine,
        caution: SCChartReferenceLine? = nil,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        paddingRatio: Double = 0.03
    ) {
        let points = SCChartPoint.make(values: values, labels: labels)
        let referenceValues = [goal.value] + (caution.map { [$0.value] } ?? [])
        self.init(
            points: points,
            goal: goal,
            caution: caution,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(
                values: points.map(\.value) + referenceValues,
                baseZero: true,
                paddingRatio: paddingRatio
            )
        )
    }

    public var body: some View {
        let referenceLines = (caution.map { [$0] } ?? []) + [goal]

        SCComposedChart(
            marks: [.line(points, style: seriesStyle)],
            overlays: [.referenceLines(referenceLines)],
            axesStyle: axesStyle,
            domain: domain
        )
    }
}
