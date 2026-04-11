//
//  SwiftUIView.swift
//  
//
//  Created by fung on 15/12/2021.
//

import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct SCLineChart: View {
    let chartData: [SCLineChartData]
    let chartConfig: SCLineChartConfig
    
    @available(*, deprecated, message: "Use SCNativeLineChart with SCChartPoint, SCChartSeriesStyle, and SCChartAxesStyle instead.")
    public init(config: SCLineChartConfig) {
        self.chartData = config.chartData
        self.chartConfig = config
    }
    
    public var body: some View {
        SCNativeLineChart(
            points: chartData.scNativePoints,
            seriesStyle: chartConfig.scNativeSeriesStyle,
            axesStyle: chartConfig.scNativeAxesStyle,
            domain: chartConfig.scNativeDomain
        )
        .padding(.all, 5)
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct SCLineChart_Previews: PreviewProvider {
    static public var previews: some View {
        SCNativeLineChart(
            points: SCPreviewFixtures.nativeLinePoints,
            axesStyle: SCPreviewFixtures.nativeAxesStyle,
            domain: SCChartDomain.make(values: SCPreviewFixtures.nativeLinePoints.map(\.value))
        )
            .frame(width: 100, height: 100)
    }
}
