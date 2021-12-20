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
    
    public static func getLineChartData(data: [Int]) -> [SCLineChartData]{
        var chartData: [SCLineChartData] = [SCLineChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCLineChartData(Double(value)))
        }
        return chartData
    }
    
    public static func getBarChartData(data: [Double]) -> [SCBarChartData]{
        var chartData: [SCBarChartData] = [SCBarChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCBarChartData(value))
        }
        return chartData
    }
    
    public static func getBarChartData(data: [Int]) -> [SCBarChartData]{
        var chartData: [SCBarChartData] = [SCBarChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCBarChartData(Double(value)))
        }
        return chartData
    }
    
    public static func getHistogramData(data: [Double]) -> [SCHistogramData]{
        var chartData: [SCHistogramData] = [SCHistogramData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCHistogramData(value))
        }
        return chartData
    }
    
    public static func getHistogramData(data: [Int]) -> [SCHistogramData]{
        var chartData: [SCHistogramData] = [SCHistogramData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCHistogramData(Double(value)))
        }
        return chartData
    }
    
    public static func getQuadCurveData(data: [Double]) -> [SCQuadCurveData]{
        var chartData: [SCQuadCurveData] = [SCQuadCurveData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCQuadCurveData(value))
        }
        return chartData
    }
    
    public static func getQuadCurveData(data: [Int]) -> [SCQuadCurveData]{
        var chartData: [SCQuadCurveData] = [SCQuadCurveData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCQuadCurveData(Double(value)))
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
    
    public static func getRangeChartData(lower: [Int], upper: [Int]) -> [SCRangeChartData]? {
        if lower.count == upper.count {
            var returnedData = [SCRangeChartData]()
            for i in 0..<lower.count {
                returnedData.append(SCRangeChartData(Double(lower[i]), Double(upper[i])))
            }
            return returnedData
        }
        else {
            assert(lower.count == upper.count , "The count of lower and upper elements are different. Please fix. They should be the same.")
            return nil
        }
    }
    
    public static func getRangeChartData(data: [(lower: Double, upper: Double)]) -> [SCRangeChartData]? {
        var returnedData = [SCRangeChartData]()
        for i in 0..<data.count {
            returnedData.append(SCRangeChartData(data[i].lower, data[i].upper))
        }
        return returnedData
    }
    
    public static func getRangeChartData(data: [(lower: Int, upper: Int)]) -> [SCRangeChartData]? {
        var returnedData = [SCRangeChartData]()
        for i in 0..<data.count {
            returnedData.append(SCRangeChartData(Double(data[i].lower), Double(data[i].upper)))
        }
        return returnedData
    }
    
}
