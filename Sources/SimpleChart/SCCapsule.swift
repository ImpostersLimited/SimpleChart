//
//  SwiftUIView.swift
//  
//
//  Created by fung on 13/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
struct SCCapsule: View {
    
    @State var config: SCRangeChartConfig
    @State var data: SCRangeChartData
    @State var size: CGSize
    var width: Double
    var height: Double
    var offset: Double
    
    public init(_ config: SCRangeChartConfig, _ data: SCRangeChartData, _ size: CGSize){
        self.config = config
        self.data = data
        self.size = size
        self.width = config.widthFactor * size.width
        self.height = (size.height * (data.upper - data.lower)) / (config.max - config.min)
        self.offset = (size.height * (data.lower - config.min)) / (config.max - config.min)
    }
    
    var body: some View {
        Capsule()
            .frame(width: width, height: height)
            .offset(x: 0, y: -offset)
    }
}

@available(iOS 15, macOS 12.0, *)
struct SCCapsule_Previews: PreviewProvider {
    static var previews: some View {
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
        SCCapsule(SCRangeChartConfig(temp), SCRangeChartData(1.0, 5.0), CGSize(width: 100, height: 100))
    }
}
