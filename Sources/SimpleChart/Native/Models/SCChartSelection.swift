//
//  SCChartSelection.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

public struct SCChartSelection: Equatable {
    public let seriesName: String?
    public let xLabel: String?
    public let value: Double

    public init(seriesName: String? = nil, xLabel: String? = nil, value: Double) {
        self.seriesName = seriesName
        self.xLabel = xLabel
        self.value = value
    }
}
