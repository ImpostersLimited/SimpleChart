//
//  SwiftUIView.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI


//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
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
                .stroke(lineWidth: config.strokeWidth)
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
