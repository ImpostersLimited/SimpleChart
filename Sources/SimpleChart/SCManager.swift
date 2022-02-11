//
//  File.swift
//  
//
//  Created by fung on 13/12/2021.
//

import Foundation

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public class SCManager {
    
    private init(){}
    
    public static func defaultBarChartData() -> [SCBarChartData] {
        return [SCBarChartData(3.1),SCBarChartData(2.1),SCBarChartData(3.1),SCBarChartData(5.1), SCBarChartData(9.9)]
    }
    
    public static func defaultHistogramData() -> [SCHistogramData] {
        return [SCHistogramData(3.1),SCHistogramData(2.1),SCHistogramData(3.1),SCHistogramData(5.1), SCHistogramData(9.9)]
    }
    
    public static func defaultLineChartData() -> [SCLineChartData] {
        return [SCLineChartData(3.1),SCLineChartData(2.1),SCLineChartData(3.1),SCLineChartData(5.1), SCLineChartData(9.9)]
    }
    
    public static func defaultQuadCurveData() -> [SCQuadCurveData] {
        return [SCQuadCurveData(3.1),SCQuadCurveData(2.1),SCQuadCurveData(3.1),SCQuadCurveData(5.1), SCQuadCurveData(9.9)]
    }
    
    public static func defaultRangeChartData() -> [SCRangeChartData] {
        return [SCRangeChartData(1.0, 3.1),SCRangeChartData(1.0, 2.1),SCRangeChartData(1.0, 3.1),SCRangeChartData(1.0, 5.1), SCRangeChartData(1.0, 9.9)]
    }
    
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
                if lower[i] <= upper[i] {
                    returnedData.append(SCRangeChartData(lower[i], upper[i]))
                }
                else {
                    returnedData.append(SCRangeChartData(upper[i], lower[i]))
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
                    returnedData.append(SCRangeChartData(Double(lower[i]), Double(upper[i])))
                }
                else {
                    returnedData.append(SCRangeChartData(Double(upper[i]),Double(lower[i])))
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
                returnedData.append(SCRangeChartData(data[i].lower, data[i].upper))
            }
            else {
                returnedData.append(SCRangeChartData(data[i].upper,data[i].lower))
            }
        }
        return returnedData
    }
    
    public static func getRangeChartData(data: [(lower: Int, upper: Int)]) -> [SCRangeChartData] {
        var returnedData = [SCRangeChartData]()
        for i in 0..<data.count {
            if data[i].lower <= data[i].upper{
                returnedData.append(SCRangeChartData(Double(data[i].lower), Double(data[i].upper)))
            }
            else {
                returnedData.append(SCRangeChartData(Double(data[i].upper),Double(data[i].lower)))
            }
        }
        return returnedData
    }
    
}
