//
//  SCBarChartInterval.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCBarChartInterval: View {
    
    @State var config: SCBarChartConfig
    @State var size: CGSize
    
    init(_ config: SCBarChartConfig, _ size: CGSize){
        self.config = config
        self.size = size
    }
    
    internal var body: some View {
        ZStack(alignment: .topLeading){
            Path { path in
                let xRoot = 0.0
                if config.showXAxis && config.showYAxis {
                    path.move(to: CGPoint(x: xRoot, y: 0.0))
                    path.addLine(to: CGPoint(x: xRoot, y: size.height))
                    path.addLine(to: CGPoint(x: size.width, y: size.height))
                }
                else if config.showXAxis || config.showYAxis {
                    if config.showYAxis {
                        path.move(to: CGPoint(x: xRoot, y: 0.0))
                        path.addLine(to: CGPoint(x: xRoot, y: size.height))
                    }
                    else if config.showXAxis {
                        path.move(to: CGPoint(x: xRoot, y: size.height))
                        path.addLine(to: CGPoint(x: size.width, y: size.height))
                    }
                }
                if config.showInterval {
                    for i in 1..<(config.numOfInterval+1) {
                        let intervalPoints = Double(size.height)/Double(config.numOfInterval + 1)
                        path.move(to: CGPoint(x: xRoot, y: size.height - (intervalPoints*Double(i))))
                        path.addLine(to: CGPoint(x: size.width, y: size.height - (intervalPoints*Double(i))))
                    }
                }
            }.stroke(lineWidth: config.intervalLineWidth).foregroundColor(config.intervalColor)
            if config.showYAxisFigure {
                VStack(alignment: .leading){
                    Text(String(format: "%.0f", config.actualMax.rounded(.up)))
                        .font(.system(size: size.height*config.yAxisFigureFontFactor))
                        .foregroundColor(config.yAxisFigureColor)
                        .offset(x: size.width/100, y: 0)
                    Spacer()
                    Text(String(format: "%.0f", config.actualMin.rounded(.up)))
                        .font(.system(size: size.height*config.yAxisFigureFontFactor))
                        .foregroundColor(config.yAxisFigureColor)
                        .offset(x: size.width/100, y: 0)
                }
            }
        }
    }
}
