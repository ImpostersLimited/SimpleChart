//
//  File.swift
//  
//
//  Created by fung on 13/12/2021.
//

import Foundation

public let manager = SCManager.manager

public class SCManager {
    static let manager = SCManager()
    private init(){}
    
    public func convertDataType(data: [Double]) -> [SCChartData]{
        var chartData: [SCChartData] = [SCChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCChartData(value))
        }
        return chartData
    }
}
