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
/// Deprecated helper namespace that converts primitive arrays into the legacy chart data models.
public class SCManager {
    
    private init(){}
    
    /// Returns the default sample data used by the deprecated legacy bar-chart API.
    public static func defaultBarChartData() -> [SCBarChartData] {
        return [3.1, 2.1, 3.1, 5.1, 9.9].map { SCBarChartData(rawValue: $0) }
    }
    
    /// Returns the default sample data used by the deprecated legacy histogram API.
    public static func defaultHistogramData() -> [SCHistogramData] {
        return [3.1, 2.1, 3.1, 5.1, 9.9].map { SCHistogramData(rawValue: $0) }
    }
    
    /// Returns the default sample data used by the deprecated legacy line-chart API.
    public static func defaultLineChartData() -> [SCLineChartData] {
        return [3.1, 2.1, 3.1, 5.1, 9.9].map { SCLineChartData(rawValue: $0) }
    }
    
    /// Returns the default sample data used by the deprecated legacy quad-curve API.
    public static func defaultQuadCurveData() -> [SCQuadCurveData] {
        return [3.1, 2.1, 3.1, 5.1, 9.9].map { SCQuadCurveData(rawValue: $0) }
    }
    
    /// Returns the default sample data used by the deprecated legacy range-chart API.
    public static func defaultRangeChartData() -> [SCRangeChartData] {
        return [(1.0, 3.1), (1.0, 2.1), (1.0, 3.1), (1.0, 5.1), (1.0, 9.9)].map {
            SCRangeChartData(rawLower: $0.0, rawUpper: $0.1)
        }
    }
    
    /// Converts floating-point values into deprecated legacy line-chart data models.
    public static func getLineChartData(data: [Double]) -> [SCLineChartData]{
        var chartData: [SCLineChartData] = [SCLineChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCLineChartData(rawValue: value))
        }
        return chartData
    }
    
    /// Converts integer values into deprecated legacy line-chart data models.
    public static func getLineChartData(data: [Int]) -> [SCLineChartData]{
        var chartData: [SCLineChartData] = [SCLineChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCLineChartData(rawValue: Double(value)))
        }
        return chartData
    }
    
    /// Converts floating-point values into deprecated legacy bar-chart data models.
    public static func getBarChartData(data: [Double]) -> [SCBarChartData]{
        var chartData: [SCBarChartData] = [SCBarChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCBarChartData(rawValue: value))
        }
        return chartData
    }
    
    /// Converts integer values into deprecated legacy bar-chart data models.
    public static func getBarChartData(data: [Int]) -> [SCBarChartData]{
        var chartData: [SCBarChartData] = [SCBarChartData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCBarChartData(rawValue: Double(value)))
        }
        return chartData
    }
    
    /// Converts floating-point values into deprecated legacy histogram data models.
    public static func getHistogramData(data: [Double]) -> [SCHistogramData]{
        var chartData: [SCHistogramData] = [SCHistogramData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCHistogramData(rawValue: value))
        }
        return chartData
    }
    
    /// Converts integer values into deprecated legacy histogram data models.
    public static func getHistogramData(data: [Int]) -> [SCHistogramData]{
        var chartData: [SCHistogramData] = [SCHistogramData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCHistogramData(rawValue: Double(value)))
        }
        return chartData
    }
    
    /// Converts floating-point values into deprecated legacy quad-curve data models.
    public static func getQuadCurveData(data: [Double]) -> [SCQuadCurveData]{
        var chartData: [SCQuadCurveData] = [SCQuadCurveData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCQuadCurveData(rawValue: value))
        }
        return chartData
    }
    
    /// Converts integer values into deprecated legacy quad-curve data models.
    public static func getQuadCurveData(data: [Int]) -> [SCQuadCurveData]{
        var chartData: [SCQuadCurveData] = [SCQuadCurveData]()
        for (_, value) in data.enumerated(){
            chartData.append(SCQuadCurveData(rawValue: Double(value)))
        }
        return chartData
    }
    
    /// Converts lower and upper floating-point bounds into deprecated legacy range-chart data models.
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
    
    /// Converts lower and upper integer bounds into deprecated legacy range-chart data models.
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
    
    /// Converts tuple-based floating-point ranges into deprecated legacy range-chart data models.
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
    
    /// Converts tuple-based integer ranges into deprecated legacy range-chart data models.
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
