//
//  SwiftUIView.swift
//
//
//  Created by fung on 13/12/2021.
//

import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct SCRangeChart: View {
    let chartData: [SCRangeChartData]
    let chartConfig: SCRangeChartConfig
    
    @available(*, deprecated, message: "Use SCNativeRangeChart with SCChartRangePoint, SCChartSeriesStyle, and SCChartAxesStyle instead.")
    public init(config: SCRangeChartConfig) {
        self.chartData = config.chartData
        self.chartConfig = config
    }
    
    public var body: some View {
        SCNativeRangeChart(
            points: chartData.scNativeRangePoints,
            seriesStyle: chartConfig.scNativeSeriesStyle,
            axesStyle: chartConfig.scNativeAxesStyle,
            domain: chartConfig.scNativeDomain
        )
        .padding(.all, 5)
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct SCChart_Previews: PreviewProvider {
    static public var previews: some View {
        SCNativeRangeChart(
            points: SCPreviewFixtures.nativeRangePoints,
            seriesStyle: SCChartSeriesStyle(colors: [.pink], strokeWidth: 2, strokeOnly: false),
            axesStyle: SCPreviewFixtures.nativeAxesStyle,
            domain: SCChartDomain.make(
                lowerValues: SCPreviewFixtures.nativeRangePoints.map(\.lower),
                upperValues: SCPreviewFixtures.nativeRangePoints.map(\.upper),
                paddingRatio: 0.08
            )
        )
            .frame(width: 300, height: 300)
    }
}
