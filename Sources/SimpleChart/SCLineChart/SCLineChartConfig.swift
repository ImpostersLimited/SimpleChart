//
//  SCLineChartConfig.swift
//  
//
//  Created by fung on 15/12/2021.
//

import Foundation
import SwiftUI

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCLineChartConfig {
    let chartData: [SCLineChartData]
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
    let strokeWidth: CGFloat
    let xLegendColor: Color
    let yLegendColor: Color
    let gradientStart: UnitPoint
    let gradientEnd: UnitPoint
    let yAxisFigureColor: Color
    let intervalLineWidth: CGFloat
    let intervalColor: Color
    
    public init(chartData: [SCLineChartData], baseZero: Bool = false, showInterval: Bool = false, showXAxis: Bool = false, showYAxis: Bool = false, showYAxisFigure: Bool = false, showLegend: Bool = false, showLabel: Bool = false, intervalColor: Color = .secondary, intervalLineWidth: CGFloat = 0.5, stroke: Bool = false, strokeWidth: CGFloat = 1, color: [Color] = [.primary], numOfInterval: Int = 3, xLegend: String = "", yLegend: String = "", xLegendColor: Color = .primary, yLegendColor: Color = .primary, gradientStart: UnitPoint = .top, gradientEnd: UnitPoint = .bottom, yAxisFigureColor: Color = .secondary, minLower: Double = Double.infinity, maxUpper: Double = -Double.infinity){
        var chartData = chartData
        if chartData.isEmpty {
            chartData = SCManager.defaultLineChartData()
        }
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
        //self.baseZero = baseZero
        var minLower = minLower
        var maxUpper = maxUpper
        if minLower == Double.infinity {
            for item in chartData {
                if item.value < minLower {
                    minLower = item.value
                }
            }
        }
        if maxUpper == -Double.infinity {
            for item in chartData {
                if item.value > maxUpper {
                    maxUpper = item.value
                }
            }
        }
        self.showXAxis = showXAxis
        self.showYAxis = showYAxis
        self.showYAxisFigure = showYAxisFigure
        self.stroke = stroke
        self.strokeWidth = strokeWidth
        self.xLegendColor = xLegendColor
        self.yLegendColor = yLegendColor
        self.gradientStart = gradientStart
        self.gradientEnd = gradientEnd
        // add margin below and above upper and lower bound, using 5% of lower bound value
        if self.baseZero {
            if maxUpper != minLower {
                self.min = 0
                self.max = maxUpper + ((maxUpper-minLower)*0.03)
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
                self.min = minLower - ((maxUpper-minLower)*0.03)
                self.max = maxUpper + ((maxUpper-minLower)*0.03)
            }
            else {
                self.min = minLower*0.97
                self.max = maxUpper*1.03
            }
            self.actualMax = maxUpper
            self.actualMin = minLower
        }
        self.showLabel = showLabel
        self.showLegend = showLegend
        self.showInterval = showInterval
        self.intervalLineWidth = intervalLineWidth
        self.intervalColor = intervalColor
        self.xLegend = xLegend
        self.yLegend = yLegend
        self.numOfInterval = numOfInterval
        self.color = color
        self.yAxisFigureColor = yAxisFigureColor
        // need to minus 1 as the number of spacing within bars is equal to count + 1
        if chartData.count > 1 {
            let temp = (Double(chartData.count)) - 1
            self.spacingFactor = 1/temp
            self.widthFactor = 1/temp
        }
        else {
            self.spacingFactor = 0
            self.widthFactor = 1
        }
    }
}
