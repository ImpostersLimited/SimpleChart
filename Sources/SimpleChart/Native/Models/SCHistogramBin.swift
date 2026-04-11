//
//  SCHistogramBin.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

public struct SCHistogramBin: Identifiable, Equatable, Codable {
    public let id: String
    public let lowerBound: Double
    public let upperBound: Double
    public let count: Int

    public init(id: String, lowerBound: Double, upperBound: Double, count: Int) {
        self.id = id
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.count = count
    }
}
