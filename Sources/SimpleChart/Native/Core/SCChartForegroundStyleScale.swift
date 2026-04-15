//
//  SCChartForegroundStyleScale.swift
//
//
//  Created by Codex on 2026-04-10.
//

import SwiftUI

/// Maps category names to colors for grouped, stacked, and composed chart legends.
public struct SCChartForegroundStyleScale: Equatable {
    public let domain: [String]
    public let range: [Color]

    /// Creates an explicit foreground-style scale from a domain/range mapping.
    public init(domain: [String], range: [Color]) {
        self.domain = domain
        self.range = range
    }
}

public extension SCChartForegroundStyleScale {
    /// Builds a categorical foreground-style scale from an ordered domain and palette.
    static func categorical(
        _ domain: [String],
        palette: [Color]
    ) -> SCChartForegroundStyleScale {
        SCChartForegroundStyleScale(domain: domain, range: palette)
    }
}
