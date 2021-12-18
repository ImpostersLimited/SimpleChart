//
//  SwiftUIView.swift
//  
//s
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
struct SCCurve: View {
    
    @State var config: SCQuadCurveConfig
    @State var size: CGSize
    var width: Double
    
    init(_ config: SCQuadCurveConfig, _ size: CGSize){
        self.config = config
        self.size = size
        self.width = config.widthFactor * size.width
    }
    
    var body: some View {
        Path{path in
            
            for i in 0..<config.segments.count {
                let tempY = size.height - ((size.height * (config.segments[i].p2 - config.min)) / (config.max - config.min))
                let controlY = size.height - ((size.height * (config.segments[i].p_control - config.min)) / (config.max - config.min))
                if i == 0 {
                    path.move(to: CGPoint(x: Double(0.0+(width*Double(i))), y: tempY))
                    path.addQuadCurve(to: CGPoint(x: Double(0.0+(width*2*Double(i))), y: tempY), control: CGPoint(x: Double(0.0+(width*2*Double(i))-1), y: controlY))
                }
                else {
                    path.addQuadCurve(to: CGPoint(x: Double(0.0+(width*2*Double(i))), y: tempY), control: CGPoint(x: Double(0.0+(width*2*Double(i))-1), y: controlY))
                }
            }
            /*
             for i in 0..<config.chartData.count{
                 let tempY = size.height - ((size.height * (config.chartData[i].value - config.min)) / (config.max - config.min))
                 if i == 0 {
                     path.move(to: CGPoint(x: Double(0.0+(width*Double(i))), y: tempY))
                 }
                 else {
                     path.addLine(to: CGPoint(x: Double(0.0+(width*Double(i))), y: tempY))
                 }
             }
             */
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            path.closeSubpath()
        }
        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .top, endPoint: .bottom))
        //.stroke()
        //.fill(Color.accentColor)
        .foregroundColor(config.foregroundColor)
    }
}

@available(iOS 15, macOS 12.0, *)
struct SCCurve_Previews: PreviewProvider {
    static var previews: some View {
        let temp: [SCQuadCurveData] = [
            SCQuadCurveData(0.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(4.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(3.0),
            SCQuadCurveData(5.0),
            SCQuadCurveData(0.5)]
        SCCurve(SCQuadCurveConfig(temp), CGSize(width: 90, height: 90))
            .frame(width: 90, height: 90)
    }
}
