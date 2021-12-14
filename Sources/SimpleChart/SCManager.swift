//
//  File.swift
//  
//
//  Created by fung on 13/12/2021.
//

import Foundation

@available(iOS 15, macOS 12.0, *)
public class SCManager {
    private init(){}
    
    public static func convertDataType(data: [Double]) -> [SCChartData]{
        var chartData: [SCChartData] = [SCChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCChartData(value))
        }
        return chartData
    }
}
