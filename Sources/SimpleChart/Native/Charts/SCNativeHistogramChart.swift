//
//  SCNativeHistogramChart.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

public struct SCNativeHistogramChart: View {
    public let bins: [SCHistogramBin]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?

    public init(
        bins: [SCHistogramBin],
        seriesStyle: SCChartSeriesStyle = SCChartSeriesStyle(),
        axesStyle: SCChartAxesStyle = SCChartAxesStyle(),
        domain: SCChartDomain? = nil
    ) {
        self.bins = bins
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
    }

    public init(
        values: [Double],
        binCount: Int = 10,
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil
    ) {
        let bins = SCHistogramBinning.makeBins(values: values, binCount: binCount)
        self.init(
            bins: bins,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain ?? .auto(values: bins.map(\.count), baseZero: true)
        )
    }

    public init<T: BinaryInteger>(
        values: [T],
        binCount: Int = 10,
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .minimal,
        domain: SCChartDomain? = nil
    ) {
        self.init(
            values: values.map(Double.init),
            binCount: binCount,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain
        )
    }

    public var body: some View {
        SCNativeChartContainer(axesStyle: axesStyle) {
            Chart(bins) { bin in
                BarMark(
                    x: .value("Bin", bin.plottedXValue),
                    y: .value("Count", bin.count)
                )
                .foregroundStyle(seriesStyle.foregroundGradient)
            }
            .scChartDomain(domain)
            .scChartAxes(axesStyle)
        }
    }
}
