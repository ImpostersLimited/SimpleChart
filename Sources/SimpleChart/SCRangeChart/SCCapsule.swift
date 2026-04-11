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
