//
//  SCQuadCurveConfig.swift
//  
//
//  Created by fung on 18/12/2021.
//

import Foundation
import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct SCQuadCurveConfig {
    var segments: [SCQuadSegment]
    let chartData: [SCQuadCurveData]
    let baseZero: Bool
    let showInterval: Bool
    let showLegend: Bool
    let showLabel: Bool
    let foregroundColor: Color
    let numOfInterval: Int?
    let xLabel: String?
    let yLabel: String?
    let min: Double
    let max: Double
    let spacingFactor: Double
    let widthFactor: Double
    let actualMax: Double
    let actualMin: Double
    
    public init(_ chartData: [SCQuadCurveData], _ baseZero: Bool = false, _ showInterval: Bool = true, _ showLegend: Bool = false, _ showLabel: Bool = false, _ foregroundColor: Color = .primary, _ numOfInterval: Int? = 3, _ xLabel: String? = nil, _ yLabel: String? = nil){
        self.chartData = chartData
        self.baseZero = baseZero
        var minLower = Double.infinity
        var maxUpper = -Double.infinity
        for item in chartData {
            if item.value < minLower {
                minLower = item.value
            }
            if item.value > maxUpper {
                maxUpper = item.value
            }
        }
        // add margin below and above upper and lower bound, using 5% of lower bound value
        if maxUpper != minLower {
            self.min = minLower - ((maxUpper-minLower)*0.03)
            self.max = maxUpper + ((maxUpper-minLower)*0.03)
        }
        else {
            self.min = minLower*0.97
            self.max = maxUpper*1.03
        }
        self.actualMax = maxUpper
        self.actualMin = minLower
        self.showLabel = showLabel
        self.showLegend = showLegend
        self.showInterval = showInterval
        self.yLabel = yLabel
        self.xLabel = xLabel
        self.numOfInterval = numOfInterval
        self.foregroundColor = foregroundColor
        self.segments = [SCQuadSegment]()
        if (chartData.count > 2) {
            for i in 0..<Int(chartData.count-1) {
                let asdf = i+1
                let temp = SCQuadSegment(chartData[i].value, chartData[asdf].value)
                segments.append(temp)
            }
        }
        /*
         for index in 0..<chartData.count {
             if index == 0{
                 let temp = SCQuadSegment(nil, chartData[index].value, chartData[Int(index+1)].value)
                 self.segments.append(temp)
             }
             else if index == chartData.count-1 {
                 let temp = SCQuadSegment(chartData[Int(index-1)].value, chartData[index].value, nil)
                 self.segments.append(temp)
             }
             else if index < chartData.count-1{
                 let temp = SCQuadSegment(chartData[Int(index-1)].value, chartData[index].value, chartData[Int(index+1)].value)
                 self.segments.append(temp)
             }
         }
         */
        
        // need to minus 1 as the number of spacing within bars is equal to count + 1
        if chartData.count > 1 {
            let temp = Double((chartData.count-1)*4)
            self.spacingFactor = 1/temp
            self.widthFactor = 1/temp
        }
        else {
            self.spacingFactor = 0
            self.widthFactor = 1
        }
    }
}
