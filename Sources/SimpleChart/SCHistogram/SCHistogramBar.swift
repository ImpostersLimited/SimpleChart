//
//  SCHistogramBar.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
struct SCHistogramBar: View {
    
    @State var config: SCHistogramConfig
    @State var data: SCHistogramData
    @State var size: CGSize
    var width: Double
    var height: Double
    
    init(_ config: SCHistogramConfig, _ data: SCHistogramData, _ size: CGSize){
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
            .border(Color.gray, width: 1)
    }
}

@available(iOS 15, macOS 12.0, *)
struct SCHistogramBar_Previews: PreviewProvider {
    static var previews: some View {
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
        SCHistogramBar(SCHistogramConfig(temp), SCHistogramData(1.0), CGSize(width: 100, height: 100))
    }
}
