//
//  SCHistogramBar.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCHistogramBar: View {
    
    @State var config: SCHistogramConfig
    @State var data: SCHistogramData
    @State var size: CGSize
    var width: Double
    var height: Double
    
    internal init(_ config: SCHistogramConfig, _ data: SCHistogramData, _ size: CGSize){
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

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCHistogramBar_Previews: PreviewProvider {
    static internal var previews: some View {
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
        SCHistogramBar(SCHistogramConfig(chartData: temp), SCHistogramData(1.0), CGSize(width: 100, height: 100))
    }
}
