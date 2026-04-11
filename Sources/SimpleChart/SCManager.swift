//
//  File.swift
//  
//
//  Created by fung on 13/12/2021.
//

import Foundation

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
@available(*, deprecated, message: "Use direct SCChartPoint and SCChartRangePoint construction for the native chart wrappers instead.")
public class SCManager {
    
    private init(){}
    
    public static func defaultBarChartData() -> [SCBarChartData] {
        return [3.1, 2.1, 3.1, 5.1, 9.9].map { SCBarChartData(rawValue: $0) }
    }
    
    public static func defaultHistogramData() -> [SCHistogramData] {
        return [3.1, 2.1, 3.1, 5.1, 9.9].map { SCHistogramData(rawValue: $0) }
    }
    
    public static func defaultLineChartData() -> [SCLineChartData] {
        return [3.1, 2.1, 3.1, 5.1, 9.9].map { SCLineChartData(rawValue: $0) }
    }
    
    public static func defaultQuadCurveData() -> [SCQuadCurveData] {
        return [3.1, 2.1, 3.1, 5.1, 9.9].map { SCQuadCurveData(rawValue: $0) }
    }
    
    public static func defaultRangeChartData() -> [SCRangeChartData] {
        return [(1.0, 3.1), (1.0, 2.1), (1.0, 3.1), (1.0, 5.1), (1.0, 9.9)].map {
            SCRangeChartData(rawLower: $0.0, rawUpper: $0.1)
        }
    }
    
    public static func getLineChartData(data: [Double]) -> [SCLineChartData]{
        var chartData: [SCLineChartData] = [SCLineChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCLineChartData(rawValue: value))
        }
        return chartData
    }
    
    public static func getLineChartData(data: [Int]) -> [SCLineChartData]{
        var chartData: [SCLineChartData] = [SCLineChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCLineChartData(rawValue: Double(value)))
        }
        return chartData
    }
    
    public static func getBarChartData(data: [Double]) -> [SCBarChartData]{
        var chartData: [SCBarChartData] = [SCBarChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCBarChartData(rawValue: value))
        }
        return chartData
    }
    
    public static func getBarChartData(data: [Int]) -> [SCBarChartData]{
        var chartData: [SCBarChartData] = [SCBarChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCBarChartData(rawValue: Double(value)))
        }
        return chartData
    }
    
    public static func getHistogramData(data: [Double]) -> [SCHistogramData]{
        var chartData: [SCHistogramData] = [SCHistogramData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCHistogramData(rawValue: value))
        }
        return chartData
    }
    
    public static func getHistogramData(data: [Int]) -> [SCHistogramData]{
        var chartData: [SCHistogramData] = [SCHistogramData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCHistogramData(rawValue: Double(value)))
        }
        return chartData
    }
    
    public static func getQuadCurveData(data: [Double]) -> [SCQuadCurveData]{
        var chartData: [SCQuadCurveData] = [SCQuadCurveData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCQuadCurveData(rawValue: value))
        }
        return chartData
    }
    
    public static func getQuadCurveData(data: [Int]) -> [SCQuadCurveData]{
        var chartData: [SCQuadCurveData] = [SCQuadCurveData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCQuadCurveData(rawValue: Double(value)))
        }
        return chartData
    }
    
    public static func getRangeChartData(lower: [Double], upper: [Double]) -> [SCRangeChartData]? {
        if lower.count == upper.count {
            var returnedData = [SCRangeChartData]()
            for i in 0..<lower.count {
                if lower[i] <= upper[i] {
                    returnedData.append(SCRangeChartData(rawLower: lower[i], rawUpper: upper[i]))
                }
                else {
                    returnedData.append(SCRangeChartData(rawLower: upper[i], rawUpper: lower[i]))
                }
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
                if lower[i] <= upper[i] {
                    returnedData.append(SCRangeChartData(rawLower: Double(lower[i]), rawUpper: Double(upper[i])))
                }
                else {
                    returnedData.append(SCRangeChartData(rawLower: Double(upper[i]), rawUpper: Double(lower[i])))
                }
            }
            return returnedData
        }
        else {
            assert(lower.count == upper.count , "The count of lower and upper elements are different. Please fix. They should be the same.")
            return nil
        }
    }
    
    public static func getRangeChartData(data: [(lower: Double, upper: Double)]) -> [SCRangeChartData] {
        var returnedData = [SCRangeChartData]()
        for i in 0..<data.count {
            if data[i].lower <= data[i].upper{
                returnedData.append(SCRangeChartData(rawLower: data[i].lower, rawUpper: data[i].upper))
            }
            else {
                returnedData.append(SCRangeChartData(rawLower: data[i].upper, rawUpper: data[i].lower))
            }
        }
        return returnedData
    }
    
    public static func getRangeChartData(data: [(lower: Int, upper: Int)]) -> [SCRangeChartData] {
        var returnedData = [SCRangeChartData]()
        for i in 0..<data.count {
            if data[i].lower <= data[i].upper{
                returnedData.append(SCRangeChartData(rawLower: Double(data[i].lower), rawUpper: Double(data[i].upper)))
            }
            else {
                returnedData.append(SCRangeChartData(rawLower: Double(data[i].upper), rawUpper: Double(data[i].lower)))
            }
        }
        return returnedData
    }
    
}
