//
//  SCChartLegend.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

public enum SCChartLegendVisibility: String, Codable, Equatable {
    case automatic
    case visible
    case hidden
}

public enum SCChartLegendPosition: String, Codable, Equatable {
    case automatic
    case top
    case bottom
    case leading
    case trailing
    case overlay
}

public struct SCChartLegend: Equatable {
    public let visibility: SCChartLegendVisibility
    public let position: SCChartLegendPosition
    public let alignment: Alignment
    public let spacing: CGFloat

    public init(
        visibility: SCChartLegendVisibility = .automatic,
        position: SCChartLegendPosition = .automatic,
        alignment: Alignment = .center,
        spacing: CGFloat = 8
    ) {
        self.visibility = visibility
        self.position = position
        self.alignment = alignment
        self.spacing = max(spacing, 0)
    }
}

public extension SCChartLegend {
    static let automatic = SCChartLegend()
    static let visible = SCChartLegend(visibility: .visible)
    static let hidden = SCChartLegend(visibility: .hidden)

    static func visible(
        position: SCChartLegendPosition = .automatic,
        alignment: Alignment = .center,
        spacing: CGFloat = 8
    ) -> SCChartLegend {
        SCChartLegend(
            visibility: .visible,
            position: position,
            alignment: alignment,
            spacing: spacing
        )
    }
}
