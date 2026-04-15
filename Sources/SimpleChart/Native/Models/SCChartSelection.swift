//
//  SCChartSelection.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Captures the currently selected series, x-label, and value for interactive charts.
public struct SCChartSelection: Equatable {
    public let seriesName: String?
    public let xLabel: String?
    public let value: Double

    /// Creates a selection snapshot from optional series and x-label metadata plus a numeric value.
    public init(seriesName: String? = nil, xLabel: String? = nil, value: Double) {
        self.seriesName = seriesName
        self.xLabel = xLabel
        self.value = value
    }
}
