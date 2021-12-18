//
//  SCBarChartData.swift
//  
//
//  Created by fung on 18/12/2021.
//

import Foundation

@available(iOS 15, macOS 12.0, *)
public struct SCBarChartData: Codable, Equatable {
    
    public init(_ value: Double){
        self.value = value
    }
    let value: Double
}
