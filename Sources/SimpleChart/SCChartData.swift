//
//  File.swift
//  
//
//  Created by fung on 13/12/2021.
//

import Foundation

@available(iOS 15, macOS 12.0, *)
public struct SCChartData: Codable, Equatable {
    public init(_ value: Double){
        self.value = value
    }
    let value: Double
}
