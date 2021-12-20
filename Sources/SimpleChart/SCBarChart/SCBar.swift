//
//  SwiftUIView.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
internal struct SCBar: View {
    
    @State var config: SCBarChartConfig
    @State var data: SCBarChartData
    @State var size: CGSize
    var width: Double
    var height: Double
    
    internal init(_ config: SCBarChartConfig, _ data: SCBarChartData, _ size: CGSize){
        self.config = config
        self.data = data
        self.size = size
        self.width = config.widthFactor * size.width
        self.height = (size.height * (data.value - config.min)) / (config.max - config.min)
        //self.offset = (size.height * (data.lower - config.min)) / (config.max - config.min)
    }
    
    internal var body: some View {
        if config.stroke {
            Rectangle()
                .stroke()
                .fill(LinearGradient(colors: config.color, startPoint: config.gradientStart, endPoint: config.gradientEnd))
                .frame(width: width, height: height)
        }
        else {
            Rectangle()
                .fill(LinearGradient(colors: config.color, startPoint: config.gradientStart, endPoint: config.gradientEnd))
                .frame(width: width, height: height)
        }
    }
}

@available(iOS 15, macOS 12.0, *)
internal struct SCBar_Previews: PreviewProvider {
    static internal var previews: some View {
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
        SCBar(SCBarChartConfig(chartData: temp, color: [.red, .green]), SCBarChartData(1.0), CGSize(width: 100, height: 100))
    }
}
