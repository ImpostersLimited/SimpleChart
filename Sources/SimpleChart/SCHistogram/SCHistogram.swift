//
//  SwiftUIView.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct SCHistogram: View {
    
    @State var chartData: [SCHistogramData]
    @State var chartConfig: SCHistogramConfig
    
    public init(config: SCHistogramConfig) {
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
                            SCHistogramBar(self.chartConfig, self.chartData[index], proxy.size)
                                .foregroundColor(.white)
                        }
                    })
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            if chartConfig.showInterval {
                GeometryReader { proxy in
                    VStack{
                        SCHistogramInterval(chartConfig, proxy.size)
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
        }
        .padding(.all, 5)
    }
}

@available(iOS 15, macOS 12.0, *)
public struct SCHistogram_Previews: PreviewProvider {
    static public var previews: some View {
        let temp: [SCHistogramData] = [
            SCHistogramData(0.0),
            SCHistogramData(1.0),
            SCHistogramData(2.0),
            SCHistogramData(1.0),
            SCHistogramData(4.0),
            SCHistogramData(3.0),
            SCHistogramData(2.0),
            SCHistogramData(3.0),
            SCHistogramData(5.0),
            SCHistogramData(3.5)]
        SCHistogram(config: SCHistogramConfig(temp))
            .frame(width: 100.0, height: 100.0)
    }
}
