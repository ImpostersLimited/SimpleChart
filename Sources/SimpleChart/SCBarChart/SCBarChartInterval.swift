//
//  SCBarChartInterval.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
struct SCBarChartInterval: View {
    
    @State var config: SCBarChartConfig
    @State var size: CGSize
    
    init(_ config: SCBarChartConfig, _ size: CGSize){
        self.config = config
        self.size = size
    }
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Path { path in
                let xRoot = 0.0
                path.move(to: CGPoint(x: xRoot, y: 0.0))
                path.addLine(to: CGPoint(x: xRoot, y: size.height))
                path.addLine(to: CGPoint(x: size.width, y: size.height))
                for i in 1..<((config.numOfInterval ?? 0)+1) {
                    let intervalPoints = Double(size.height)/Double((config.numOfInterval ?? 0) + 1)
                    path.move(to: CGPoint(x: xRoot, y: size.height - (intervalPoints*Double(i))))
                    path.addLine(to: CGPoint(x: size.width, y: size.height - (intervalPoints*Double(i))))
                }
            }.stroke().foregroundColor(.secondary)
            VStack{
                Text(String(format: "%.0f", config.actualMax))
                    .font(.system(size: size.height/15))
                    .foregroundColor(.secondary)
                    .offset(x: size.width/100, y: 0)
                Spacer()
                Text(String(format: "%.0f", config.actualMin))
                    .font(.system(size: size.height/15))
                    .foregroundColor(.secondary)
                    .offset(x: size.width/100, y: 0)
            }
        }
    }
}

@available(iOS 15, macOS 12.0, *)
struct SCBarChartInterval_Previews: PreviewProvider {
    static var previews: some View {
        let temp: [SCBarChartData] = [
            SCBarChartData(0.0),
            SCBarChartData(1.0),
            SCBarChartData(2.0),
            SCBarChartData(1.0),
            SCBarChartData(4.0),
            SCBarChartData(3.0),
            SCBarChartData(2.0),
            SCBarChartData(3.0),
            SCBarChartData(5.0),
            SCBarChartData(3.5)]
        SCBarChartInterval(SCBarChartConfig(temp), CGSize(width: 150, height: 150))
            .frame(width: 150, height: 150)
    }
}
