//
//  SCQuadCurveConfig.swift
//  
//
//  Created by fung on 18/12/2021.
//

import Foundation
import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCQuadCurveConfig {
    var segments: [SCQuadSegment]
    let chartData: [SCQuadCurveData]
    let baseZero: Bool
    let showInterval: Bool
    let showLegend: Bool
    let showLabel: Bool
    let color: [Color]
    let numOfInterval: Int
    let xLegend: String
    let yLegend: String
    let min: Double
    let max: Double
    let spacingFactor: Double
    let widthFactor: Double
    let actualMax: Double
    let actualMin: Double
    let showXAxis: Bool
    let showYAxis: Bool
    let showYAxisFigure: Bool
    let stroke: Bool
    let xLegendColor: Color
    let yLegendColor: Color
    let gradientStart: UnitPoint
    let gradientEnd: UnitPoint
    let yAxisFigureColor: Color
    
    public init(chartData: [SCQuadCurveData], baseZero: Bool = false, showInterval: Bool = false, showXAxis: Bool = false, showYAxis: Bool = false, showYAxisFigure: Bool = false, showLegend: Bool = false, showLabel: Bool = false, stroke: Bool = false, color: [Color] = [.primary], numOfInterval: Int = 3, xLegend: String = "", yLegend: String = "", xLegendColor: Color = .primary, yLegendColor: Color = .primary, gradientStart: UnitPoint = .top, gradientEnd: UnitPoint = .bottom, yAxisFigureColor: Color = .secondary){
        self.chartData = chartData
        var allPositive = true
        for item in chartData {
            if item.value < 0 {
                allPositive = false
            }
        }
        if allPositive && baseZero {
            self.baseZero = true
        }
        else {
            self.baseZero = false
        }
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
        //self.baseZero = baseZero
        if self.baseZero {
            if maxUpper != minLower {
                self.min = 0
                self.max = maxUpper + ((maxUpper-minLower)*0.08)
            }
            else {
                self.min = 0
                self.max = maxUpper*1.03
            }
            self.actualMax = maxUpper
            self.actualMin = 0
        }
        else {
            if maxUpper != minLower {
                self.min = minLower - ((maxUpper-minLower)*0.08)
                self.max = maxUpper + ((maxUpper-minLower)*0.08)
            }
            else {
                self.min = minLower*0.97
                self.max = maxUpper*1.03
            }
            self.actualMax = maxUpper
            self.actualMin = minLower
        }
        self.showXAxis = showXAxis
        self.showYAxis = showYAxis
        self.showYAxisFigure = showYAxisFigure
        self.stroke = stroke
        self.xLegendColor = xLegendColor
        self.yLegendColor = yLegendColor
        self.gradientStart = gradientStart
        self.gradientEnd = gradientEnd
    
        self.showLabel = showLabel
        self.showLegend = showLegend
        self.showInterval = showInterval
        self.xLegend = xLegend
        self.yLegend = yLegend
        self.numOfInterval = numOfInterval
        self.color = color
        self.yAxisFigureColor = yAxisFigureColor
        
        self.segments = [SCQuadSegment]()
        if (chartData.count > 2) {
            for i in 0..<Int(chartData.count-1) {
                let asdf = i+1
                let temp = SCQuadSegment(chartData[i].value, chartData[asdf].value)
                segments.append(temp)
            }
        }
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
