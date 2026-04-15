//
//  SCLineChartData.swift
//  
//
//  Created by fung on 13/12/2021.
//

import Foundation

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
/// Deprecated legacy data point for the original line-chart API.
public struct SCLineChartData: Codable, Equatable {
    init(rawValue: Double) {
        self.value = rawValue
    }

    @available(*, deprecated, message: "Use SCChartPoint instead.")
    /// Creates a legacy line-chart data point from a numeric value.
    public init(_ value: Double){
        self.value = value
    }
    let value: Double
}
