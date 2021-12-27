//
//  SwiftUIView.swift
//  
//
//  Created by fung on 15/12/2021.
//

import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCLineChart: View {
    
    @State var chartData: [SCLineChartData]
    @State var chartConfig: SCLineChartConfig
    
    public init(config: SCLineChartConfig) {
        self.chartData = config.chartData
        self.chartConfig = config
    }
    
    public var body: some View {
        ZStack{
            GeometryReader { proxy in
                ZStack{
                    SCLine(chartConfig, proxy.size)
                        .frame(height: proxy.size.height)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            GeometryReader { proxy in
                VStack{
                    SCLineChartInterval(chartConfig, proxy.size)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .padding(.all, 5)
    }
}

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCLineChart_Previews: PreviewProvider {
    static public var previews: some View {
        let temp: [SCLineChartData] = [
            SCLineChartData(0.0),
            SCLineChartData(9.0),
            SCLineChartData(1.0),
            SCLineChartData(1.0),
            SCLineChartData(4.0),
            SCLineChartData(7.0),
            SCLineChartData(2.0),
            SCLineChartData(3.0),
            SCLineChartData(10.0),
            SCLineChartData(0)]
        SCLineChart(config: SCLineChartConfig(chartData: temp))
            .frame(width: 100, height: 100)
    }
}
