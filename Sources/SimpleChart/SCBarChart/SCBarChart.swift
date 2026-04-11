//
//  SCBarChart.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct SCBarChart: View {
    let chartData: [SCBarChartData]
    let chartConfig: SCBarChartConfig
    
    @available(*, deprecated, message: "Use SCNativeBarChart with SCChartPoint, SCChartSeriesStyle, and SCChartAxesStyle instead.")
    public init(config: SCBarChartConfig) {
        self.chartData = config.chartData
        self.chartConfig = config
    }
    
    public var body: some View {
        Group {
            if chartConfig.stroke {
                legacyBody
            } else {
                SCNativeBarChart(
                    points: chartData.scNativePoints,
                    seriesStyle: chartConfig.scNativeSeriesStyle,
                    axesStyle: chartConfig.scNativeAxesStyle,
                    domain: chartConfig.scNativeDomain
                )
            }
        }
        .padding(.all, 5)
    }

    private var legacyBody: some View {
        ZStack {
            GeometryReader { proxy in
                VStack {
                    Spacer().frame(maxWidth: proxy.size.width, minHeight: 0.00000000001)
                    HStack(alignment: .bottom, spacing: chartConfig.spacingFactor*proxy.size.width, content: {
                        ForEach(Array(chartData.indices), id: \.self) { index in
                            SCBar(self.chartConfig, self.chartData[index], proxy.size)
                                .foregroundColor(.white)
                        }
                    })
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            GeometryReader { proxy in
                VStack{
                    SCBarChartInterval(chartConfig, proxy.size)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct SCBarChart_Previews: PreviewProvider {
    static public var previews: some View {
        SCNativeBarChart(
            points: SCPreviewFixtures.nativeBarPoints,
            axesStyle: SCPreviewFixtures.nativeAxesStyle,
            domain: SCChartDomain.make(values: SCPreviewFixtures.nativeBarPoints.map(\.value))
        )
            .frame(width: 300, height: 300)
    }
}
