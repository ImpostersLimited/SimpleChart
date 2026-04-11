//
//  File.swift
//  
//
//  Created by fung on 14/12/2021.
//

import Foundation

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCRangeChartData: Codable, Equatable {
    init(rawLower: Double, rawUpper: Double) {
        self.lower = rawLower
        self.upper = rawUpper
    }
    
    @available(*, deprecated, message: "Use SCChartRangePoint instead.")
    public init(_ lower: Double, _ upper: Double){
        self.lower = lower
        self.upper = upper
    }
    let lower: Double
    let upper: Double
}
