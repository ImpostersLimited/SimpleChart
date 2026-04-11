//
//  SCChartForegroundStyleScale.swift
//
//
//  Created by Codex on 2026-04-10.
//

import SwiftUI

public struct SCChartForegroundStyleScale: Equatable {
    public let domain: [String]
    public let range: [Color]

    public init(domain: [String], range: [Color]) {
        self.domain = domain
        self.range = range
    }
}

public extension SCChartForegroundStyleScale {
    static func categorical(
        _ domain: [String],
        palette: [Color]
    ) -> SCChartForegroundStyleScale {
        SCChartForegroundStyleScale(domain: domain, range: palette)
    }
}
