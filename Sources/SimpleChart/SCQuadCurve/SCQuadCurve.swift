//
//  SwiftUIView 2.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCQuadCurve: View {
    
    @State var chartData: [SCQuadCurveData]
    @State var chartConfig: SCQuadCurveConfig
    
    public init(config: SCQuadCurveConfig) {
        self.chartData = config.chartData
        self.chartConfig = config
    }
    
    public var body: some View {
        ZStack{
            GeometryReader { proxy in
                ZStack{
                    SCCurve(chartConfig, proxy.size)
                        .frame(height: proxy.size.height)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            GeometryReader { proxy in
                VStack{
                    SCQuadCurveInterval(chartConfig, proxy.size)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .padding(.all, 5)
    }
}

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCQuadCurve_Previews: PreviewProvider {
    static public var previews: some View {
        let temp: [SCQuadCurveData] = [
            SCQuadCurveData(0.0),
            SCQuadCurveData(9.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(4.0),
            SCQuadCurveData(7.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(3.0),
            SCQuadCurveData(10.0),
            SCQuadCurveData(9.0)]
        SCQuadCurve(config: SCQuadCurveConfig(chartData: temp, showInterval: true, color: [.red], numOfInterval: 1, gradientStart: .topLeading, gradientEnd: .bottomTrailing))
            .frame(width: 100, height: 100)
    }
}
