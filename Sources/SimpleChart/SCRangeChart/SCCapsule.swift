//
//  SwiftUIView.swift
//  
//
//  Created by fung on 13/12/2021.
//

import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCCapsule: View {
    
    @State var config: SCRangeChartConfig
    @State var data: SCRangeChartData
    @State var size: CGSize
    var width: Double
    var height: Double
    var offset: Double
    
    internal init(_ config: SCRangeChartConfig, _ data: SCRangeChartData, _ size: CGSize){
        self.config = config
        self.data = data
        self.size = size
        self.width = config.widthFactor * size.width
        self.height = (size.height * (data.upper - data.lower)) / (config.max - config.min)
        self.offset = (size.height * (data.lower - config.min)) / (config.max - config.min)
    }
    
    internal var body: some View {
        if config.stroke {
            Capsule()
                .stroke(lineWidth: config.strokeWidth)
                .fill(LinearGradient(colors: config.color, startPoint: config.gradientStart, endPoint: config.gradientEnd))
                .frame(width: width, height: height)
                .offset(x: 0, y: -offset)
        }
        else {
            Capsule()
                .fill(LinearGradient(colors: config.color, startPoint: config.gradientStart, endPoint: config.gradientEnd))
                .frame(width: width, height: height)
                .offset(x: 0, y: -offset)
        }
    }
}

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCCapsule_Previews: PreviewProvider {
    static internal var previews: some View {
        let temp: [SCRangeChartData] = [
            SCRangeChartData(0.0, 1.0),
            SCRangeChartData(1.0, 2.0),
            SCRangeChartData(2.0, 3.0),
            SCRangeChartData(3.0, 4.0),
            SCRangeChartData(4.0, 5.0),
            SCRangeChartData(5.0, 6.0),
            SCRangeChartData(6.0, 7.0),
            SCRangeChartData(7.0, 8.0),
            SCRangeChartData(8.0, 9.0),
            SCRangeChartData(9.0, 10.0)]
        SCCapsule(SCRangeChartConfig(chartData: temp), SCRangeChartData(1.0, 5.0), CGSize(width: 100, height: 100))
    }
}
