//
//  File.swift
//  
//
//  Created by fung on 13/12/2021.
//

import Foundation

public struct SCChartData: Codable, Equatable {
    public init(_ value: Double){
        self.value = value
    }
    let value: Double
}
