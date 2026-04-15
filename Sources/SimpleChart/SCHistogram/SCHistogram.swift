//
//  SwiftUIView.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
/// Deprecated compatibility wrapper that forwards the original histogram config API to the native histogram implementation.
public struct SCHistogram: View {
    let chartData: [SCHistogramData]
    let chartConfig: SCHistogramConfig
    
    @available(*, deprecated, message: "Use SCNativeHistogramChart with SCHistogramBin or raw values plus SCChartAxesStyle instead.")
    /// Creates the deprecated histogram wrapper from a legacy configuration value.
    public init(config: SCHistogramConfig) {
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
                            SCHistogramBar(self.chartConfig, self.chartData[index], proxy.size)
                                .foregroundColor(.white)
                        }
                    })
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            GeometryReader { proxy in
                VStack{
                    SCHistogramInterval(chartConfig, proxy.size)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct SCHistogram_Previews: PreviewProvider {
    static public var previews: some View {
        SCNativeHistogramChart(
            values: SCPreviewFixtures.barValues,
            binCount: 4,
            axesStyle: SCPreviewFixtures.nativeAxesStyle
        )
            .frame(width: 100.0, height: 100.0)
    }
}
