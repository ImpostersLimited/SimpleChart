//
//  SCLineChartInterval.swift
//  
//
//  Created by fung on 15/12/2021.
//

import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCLineChartInterval: View {
    
    @State var config: SCLineChartConfig
    @State var size: CGSize
    
    internal init(_ config: SCLineChartConfig, _ size: CGSize){
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

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCLineChartInterval_Previews: PreviewProvider {
    static internal var previews: some View {
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
        SCLineChartInterval(SCLineChartConfig(chartData: temp), CGSize(width: 150, height: 150))
            .frame(width: 150, height: 150)
    }
}
