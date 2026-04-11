//
//  SwiftUIView 2.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct SCQuadCurve: View {
    let chartData: [SCQuadCurveData]
    let chartConfig: SCQuadCurveConfig
    
    @available(*, deprecated, message: "Use SCNativeQuadCurveChart with SCChartPoint, SCChartSeriesStyle, and SCChartAxesStyle instead.")
    public init(config: SCQuadCurveConfig) {
        self.chartData = config.chartData
        self.chartConfig = config
    }
    
    public var body: some View {
        SCNativeQuadCurveChart(
            points: chartData.scNativePoints,
            seriesStyle: chartConfig.scNativeSeriesStyle,
            axesStyle: chartConfig.scNativeAxesStyle,
            domain: chartConfig.scNativeDomain
        )
        .padding(.all, 5)
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct SCQuadCurve_Previews: PreviewProvider {
    static public var previews: some View {
        SCNativeQuadCurveChart(
            points: SCPreviewFixtures.nativeQuadPoints,
            seriesStyle: SCChartSeriesStyle(
                colors: [.red],
                interpolation: .catmullRom,
                gradientStart: .topLeading,
                gradientEnd: .bottomTrailing
            ),
            axesStyle: SCPreviewFixtures.nativeAxesStyle,
            domain: SCChartDomain.make(values: SCPreviewFixtures.nativeQuadPoints.map(\.value), paddingRatio: 0.08)
        )
            .frame(width: 100, height: 100)
    }
}
