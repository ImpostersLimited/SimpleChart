//
//  SwiftUIView.swift
//  
//
//  Created by fung on 15/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
struct SCLine: View {
    
    @State var config: SCLineChartConfig
    @State var size: CGSize
    var width: Double
    
    init(_ config: SCLineChartConfig, _ size: CGSize){
        self.config = config
        self.size = size
        self.width = config.widthFactor * size.width
    }
    
    var body: some View {
        Path{path in
            for i in 0..<config.chartData.count{
                let tempY = size.height - ((size.height * (config.chartData[i].value - config.min)) / (config.max - config.min))
                if i == 0 {
                    path.move(to: CGPoint(x: Double(0.0+(width*Double(i))), y: tempY))
                }
                else {
                    path.addLine(to: CGPoint(x: Double(0.0+(width*Double(i))), y: tempY))
                }
            }
        }
        .stroke()
        .foregroundColor(config.foregroundColor)
    }
}

@available(iOS 15, macOS 12.0, *)
struct SCLine_Previews: PreviewProvider {
    static var previews: some View {
        let temp: [SCLineChartData] = [
            SCLineChartData(0.0),
            SCLineChartData(1.0),
            SCLineChartData(2.0),
            SCLineChartData(1.0),
            SCLineChartData(4.0),
            SCLineChartData(3.0),
            SCLineChartData(2.0),
            SCLineChartData(3.0),
            SCLineChartData(5.0),
            SCLineChartData(3.5)]
        SCLine(SCLineChartConfig(temp), CGSize(width: 90, height: 90))
            .frame(width: 90, height: 90)
    }
}
