//
//  SCQuadCurveInterval.swift
//  
//
//  Created by fung on 18/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
struct SCQuadCurveInterval: View {
    
    @State var config: SCQuadCurveConfig
    @State var size: CGSize
    
    init(_ config: SCQuadCurveConfig, _ size: CGSize){
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
struct SCQuadCurveInterval_Previews: PreviewProvider {
    static var previews: some View {
        let temp: [SCQuadCurveData] = [
            SCQuadCurveData(0.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(4.0),
            SCQuadCurveData(3.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(3.0),
            SCQuadCurveData(5.0),
            SCQuadCurveData(3.5)]
        SCQuadCurveInterval(SCQuadCurveConfig(temp), CGSize(width: 150, height: 150))
            .frame(width: 150, height: 150)
    }
}
