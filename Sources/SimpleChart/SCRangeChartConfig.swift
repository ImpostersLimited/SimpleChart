//
//  File.swift
//  
//
//  Created by fung on 13/12/2021.
//

import Foundation
import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct SCRangeChartConfig {
    
    let chartData: [SCRangeChartData]
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
    
    
    public init(_ chartData: [SCRangeChartData], _ baseZero: Bool = false, _ showInterval: Bool = false, _ showLegend: Bool = false, _ showLabel: Bool = false, _ foregroundColor: Color = .primary, _ numOfInterval: Int? = nil, _ xLabel: String? = nil, _ yLabel: String? = nil){
        self.chartData = chartData
        self.baseZero = baseZero
        var minLower = Double.infinity
        var maxUpper = -Double.infinity
        for item in chartData {
            if item.lower < minLower {
                minLower = item.lower
            }
            if item.upper > maxUpper {
                maxUpper = item.upper
            }
        }
        // add margin below and above upper and lower bound, using 5% of lower bound value
        self.min = minLower - ((maxUpper-minLower)*0.05) //
        self.max = maxUpper + ((maxUpper-minLower)*0.05) //
        self.showLabel = showLabel
        self.showLegend = showLegend
        self.showInterval = showInterval
        self.yLabel = yLabel
        self.xLabel = xLabel
        self.numOfInterval = numOfInterval
        self.foregroundColor = foregroundColor
        // need to minus 1 as the number of spacing within bars is equal to count - 1
        let temp = (Double(chartData.count)*3) - 1
        self.spacingFactor = 1/temp
        self.widthFactor = 2/temp
    }
}
