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
    
    public static func getLineChartData(data: [Double]) -> [SCLineChartData]{
        var chartData: [SCLineChartData] = [SCLineChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCLineChartData(value))
        }
        return chartData
    }
    
    public static func getRangeChartData(lower: [Double], upper: [Double]) -> [SCRangeChartData]? {
        if lower.count == upper.count {
            var returnedData = [SCRangeChartData]()
            for i in 0..<lower.count {
                returnedData.append(SCRangeChartData(lower[i], upper[i]))
            }
            return returnedData
        }
        else {
            assert(lower.count == upper.count , "The count of lower and upper elements are different. Please fix. They should be the same.")
            return nil
        }
    }
}
