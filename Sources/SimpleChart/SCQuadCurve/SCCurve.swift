//
//  SwiftUIView.swift
//  
//s
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct SCCurve: View {
    
    @State var config: SCQuadCurveConfig
    @State var size: CGSize
    var width: Double
    
    init(_ config: SCQuadCurveConfig, _ size: CGSize){
        self.config = config
        self.size = size
        self.width = config.widthFactor * size.width
    }
    
    public var body: some View {
        Path{ path in
            /*
             let tempY = size.height - ((size.height * (config.segments[i].p2 - config.min)) / (config.max - config.min))
             */
            for i in 0..<config.segments.count {
                let tempY = size.height - ((size.height * (config.segments[i].p1 - config.min)) / (config.max - config.min))
                path.move(to: CGPoint(x: Double(0.0+(width*Double(4*i))), y: tempY))
            }
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            path.closeSubpath()
        }
        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .top, endPoint: .bottom))
        .foregroundColor(config.foregroundColor)
    }
}

@available(iOS 15, macOS 12.0, *)
public struct SCCurve_Previews: PreviewProvider {
    static public var previews: some View {
        let temp: [SCQuadCurveData] = [
            SCQuadCurveData(1.0),
            SCQuadCurveData(4.0),
            SCQuadCurveData(5.0),
            SCQuadCurveData(5.0)
        ]
        SCCurve(SCQuadCurveConfig(temp), CGSize(width: 90, height: 90))
            .frame(width: 90, height: 90)
    }
}
