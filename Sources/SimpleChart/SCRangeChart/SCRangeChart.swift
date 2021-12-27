//
//  SwiftUIView.swift
//
//
//  Created by fung on 13/12/2021.
//

import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCRangeChart: View {
    
    @State var chartData: [SCRangeChartData]
    @State var chartConfig: SCRangeChartConfig
    
    public init(config: SCRangeChartConfig) {
        self.chartData = config.chartData
        self.chartConfig = config
    }
    
    public var body: some View {
        ZStack{
            GeometryReader { proxy in
                VStack{
                    Spacer().frame(width: proxy.size.width)
                    HStack(alignment: .bottom, spacing: chartConfig.spacingFactor*proxy.size.width, content: {
                        ForEach(chartData.indices) { index in
                            SCCapsule(self.chartConfig, self.chartData[index], proxy.size)
                                .foregroundColor(.white)
                        }
                    })
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            GeometryReader { proxy in
                VStack{
                    SCRangeChartInterval(chartConfig, proxy.size)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .padding(.all, 5)
    }
}

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCChart_Previews: PreviewProvider {
    static public var previews: some View {
        let temp: [SCRangeChartData] = [
            SCRangeChartData(0.0, 10.0),
            SCRangeChartData(1.0, 7.0),
            SCRangeChartData(2.0, 9.0),
            SCRangeChartData(1.0, 4.0),
            SCRangeChartData(4.0, 9.0),
            SCRangeChartData(3.0, 6.0),
            SCRangeChartData(2.0, 7.0),
            SCRangeChartData(3.0, 8.0),
            SCRangeChartData(5.0, 9.0),
            SCRangeChartData(0.0, 9.0)
        ]
        SCRangeChart(config: SCRangeChartConfig(chartData: temp))
            .frame(width: 300, height: 300)
    }
}
