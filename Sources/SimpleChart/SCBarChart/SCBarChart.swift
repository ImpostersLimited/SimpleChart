//
//  SCBarChart.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct SCBarChart: View {
    
    @State var chartData: [SCBarChartData]
    @State var chartConfig: SCBarChartConfig
    
    public init(config: SCBarChartConfig) {
        self.chartData = config.chartData
        self.chartConfig = config
    }
    
    public var body: some View {
        ZStack{
            GeometryReader { proxy in
                VStack{
                    Spacer().frame(maxWidth: proxy.size.width, minHeight: 0.00000000001)
                    HStack(alignment: .bottom, spacing: chartConfig.spacingFactor*proxy.size.width, content: {
                        ForEach(chartData.indices) { index in
                            SCBar(self.chartConfig, self.chartData[index], proxy.size)
                                .foregroundColor(.white)
                        }
                    })
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            if chartConfig.showInterval {
                GeometryReader { proxy in
                    VStack{
                        SCBarChartInterval(chartConfig, proxy.size)
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
        }
        .padding(.all, 5)
    }
}

@available(iOS 15, macOS 12.0, *)
public struct SCBarChart_Previews: PreviewProvider {
    static public var previews: some View {
        let temp: [SCBarChartData] = [
            SCBarChartData(0.0),
            SCBarChartData(1.0),
            SCBarChartData(2.0),
            SCBarChartData(1.0),
            SCBarChartData(4.0),
            SCBarChartData(3.0),
            SCBarChartData(2.0),
            SCBarChartData(3.0),
            SCBarChartData(5.0),
            SCBarChartData(3.5)]
        SCBarChart(config: SCBarChartConfig(temp))
            .frame(width: 100.0, height: 100.0)
    }
}
