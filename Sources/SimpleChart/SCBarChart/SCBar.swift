//
//  SwiftUIView.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
struct SCBar: View {
    
    @State var config: SCBarChartConfig
    @State var data: SCBarChartData
    @State var size: CGSize
    var width: Double
    var height: Double
    
    init(_ config: SCBarChartConfig, _ data: SCBarChartData, _ size: CGSize){
        self.config = config
        self.data = data
        self.size = size
        self.width = config.widthFactor * size.width
        self.height = (size.height * (data.value - config.min)) / (config.max - config.min)
        //self.offset = (size.height * (data.lower - config.min)) / (config.max - config.min)
    }
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundColor(config.foregroundColor)
    }
}

@available(iOS 15, macOS 12.0, *)
struct SCBar_Previews: PreviewProvider {
    static var previews: some View {
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
        SCBar(SCBarChartConfig(temp), SCBarChartData(1.0), CGSize(width: 100, height: 100))
    }
}
