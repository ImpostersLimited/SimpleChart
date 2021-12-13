//
//  File.swift
//  
//
//  Created by fung on 13/12/2021.
//

import Foundation

struct SCChartConfig: Codable, Equatable {
    
    let chartData: [SCChartData]
    let min: Double
    let max: Double
    let baseZero: Bool
    let spacing: Double?
    let width: Double?
    
    init(_ chartData: [SCChartData], _ baseZero: Bool = false, _ spacing: Double? = nil, _ width: Double? = nil){
        self.chartData = chartData
        self.baseZero = baseZero
        self.spacing = spacing
        self.width = width
        let tempmin = chartData.min(by: { a, b in
            return a.value > b.value
        })
        let tempmax = chartData.max(by: { a, b in
            return a.value < b.value
        })
        self.min = tempmin?.value ?? 0.0
        self.max = tempmax?.value ?? 0.0
    }
}
