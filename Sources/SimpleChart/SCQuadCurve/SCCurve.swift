//
//  SwiftUIView.swift
//  
//s
//  Created by fung on 18/12/2021.
//

import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCCurve: View {
    
    @State var config: SCQuadCurveConfig
    @State var size: CGSize
    var width: Double
    
    internal init(_ config: SCQuadCurveConfig, _ size: CGSize){
        self.config = config
        self.size = size
        self.width = config.widthFactor * size.width
    }
    
    internal var body: some View {
        if config.stroke {
            Path{ path in
                let tempY = getHeight(point: config.chartData[0].value)
                let initial = CGPoint(x: 0, y: tempY)
                var pt1 = CGPoint(x: 0, y: tempY)
                path.move(to: initial)
                for i in 0..<config.chartData.count {
                    let pt2Y = getHeight(point: config.chartData[i].value)
                    let pt2 = CGPoint(x: Double(0.0+(width*Double((4*i)))), y: pt2Y)
                    let mid = midPoint(p1: pt1, p2: pt2)
                    path.addQuadCurve(to: mid, control: controlPoint(p1: mid, p2: pt1))
                    path.addQuadCurve(to: pt2, control: controlPoint(p1: mid, p2: pt2))
                    pt1 = pt2
                }
                /*
                 path.addLine(to: CGPoint(x: size.width, y: size.height))
                 path.addLine(to: CGPoint(x: 0, y: size.height))
                 path.addLine(to: CGPoint(x: 0, y: tempY))*/
            }
            .stroke(lineWidth: config.strokeWidth)
            .fill(LinearGradient(colors: config.color, startPoint: config.gradientStart, endPoint: config.gradientEnd))
        }
        else {
            Path{ path in
                let tempY = getHeight(point: config.chartData[0].value)
                let initial = CGPoint(x: 0, y: tempY)
                var pt1 = CGPoint(x: 0, y: tempY)
                path.move(to: initial)
                for i in 0..<config.chartData.count {
                    let pt2Y = getHeight(point: config.chartData[i].value)
                    let pt2 = CGPoint(x: Double(0.0+(width*Double((4*i)))), y: pt2Y)
                    let mid = midPoint(p1: pt1, p2: pt2)
                    path.addQuadCurve(to: mid, control: controlPoint(p1: mid, p2: pt1))
                    path.addQuadCurve(to: pt2, control: controlPoint(p1: mid, p2: pt2))
                    pt1 = pt2
                }
                path.addLine(to: CGPoint(x: size.width, y: size.height))
                path.addLine(to: CGPoint(x: 0, y: size.height))
                path.addLine(to: CGPoint(x: 0, y: tempY))
            }
            .fill(LinearGradient(colors: config.color, startPoint: config.gradientStart, endPoint: config.gradientEnd))
        }
    }
    
    
    private func getHeight(point: Double) -> Double {
        let temp = size.height - ((size.height * (point - config.min)) / (config.max - config.min))
        return temp
    }
    private func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    private func controlPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = midPoint(p1: p1, p2: p2)
        let diffY = abs(p2.y - controlPoint.y)
        
        if p1.y < p2.y {
            controlPoint.y += diffY
        } else if p1.y > p2.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
}

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCCurve_Previews: PreviewProvider {
    static internal var previews: some View {
        let temp: [SCQuadCurveData] = [
            SCQuadCurveData(1.0),
            SCQuadCurveData(4.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(5.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(5.0)
        ]
        SCCurve(SCQuadCurveConfig(chartData: temp), CGSize(width: 90, height: 90))
            .frame(width: 90, height: 90)
    }
}
