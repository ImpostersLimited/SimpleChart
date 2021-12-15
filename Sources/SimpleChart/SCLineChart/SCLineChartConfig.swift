//
//  File.swift
//  
//
//  Created by fung on 15/12/2021.
//

import Foundation
import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct SCLineChartConfig {
    let chartData: [SCLineChartData]
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
    
    public init(_ chartData: [SCLineChartData], _ baseZero: Bool = false, _ showInterval: Bool = true, _ showLegend: Bool = false, _ showLabel: Bool = false, _ foregroundColor: Color = .primary, _ numOfInterval: Int? = 3, _ xLabel: String? = nil, _ yLabel: String? = nil){
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
        self.min = minLower - ((maxUpper-minLower)*0.03)
        self.max = maxUpper + ((maxUpper-minLower)*0.03)
        self.actualMax = maxUpper
        self.actualMin = minLower
        self.showLabel = showLabel
        self.showLegend = showLegend
        self.showInterval = showInterval
        self.yLabel = yLabel
        self.xLabel = xLabel
        self.numOfInterval = numOfInterval
        self.foregroundColor = foregroundColor
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
