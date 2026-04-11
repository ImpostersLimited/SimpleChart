//
//  SCQuadCurveData.swift
//  
//
//  Created by fung on 18/12/2021.
//

import Foundation

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public struct SCQuadCurveData: Codable, Equatable {
    init(rawValue: Double) {
        self.value = rawValue
    }

    @available(*, deprecated, message: "Use SCChartPoint instead.")
    public init(_ value: Double){
        self.value = value
    }
    let value: Double
}
