//
//  SwiftUIView.swift
//  
//
//  Created by fung on 15/12/2021.
//

import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCLine: View {
    
    @State var config: SCLineChartConfig
    @State var size: CGSize
    var width: Double
    
    internal init(_ config: SCLineChartConfig, _ size: CGSize){
        self.config = config
        self.size = size
        self.width = config.widthFactor * size.width
    }
    
    internal var body: some View {
        if config.stroke {
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
                /*
                 path.addLine(to: CGPoint(x: size.width, y: size.height))
                 path.addLine(to: CGPoint(x: 0, y: size.height))
                 path.closeSubpath()
                 */
            }
            .stroke(lineWidth: config.strokeWidth)
            .fill(LinearGradient(colors: config.color, startPoint: config.gradientStart, endPoint: config.gradientEnd))
        }
        else {
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
                path.addLine(to: CGPoint(x: size.width, y: size.height))
                path.addLine(to: CGPoint(x: 0, y: size.height))
                path.closeSubpath()
            }
            .fill(LinearGradient(colors: config.color, startPoint: config.gradientStart, endPoint: config.gradientEnd))
        }
    }
}
