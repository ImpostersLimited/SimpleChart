//
//  SCChartPlotStyle.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// Styles the background, padding, and border of a chart plot area.
public struct SCChartPlotStyle: Equatable {
    public let backgroundColor: Color
    public let backgroundOpacity: Double
    public let cornerRadius: CGFloat
    public let padding: CGFloat
    public let clipContent: Bool
    public let borderColor: Color?
    public let borderWidth: CGFloat

    /// Creates a plot-area style from explicit background, border, and padding values.
    public init(
        backgroundColor: Color = .clear,
        backgroundOpacity: Double = 0,
        cornerRadius: CGFloat = 0,
        padding: CGFloat = 0,
        clipContent: Bool = false,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0
    ) {
        self.backgroundColor = backgroundColor
        self.backgroundOpacity = min(max(backgroundOpacity, 0), 1)
        self.cornerRadius = max(cornerRadius, 0)
        self.padding = max(padding, 0)
        self.clipContent = clipContent
        self.borderColor = borderColor
        self.borderWidth = max(borderWidth, 0)
    }
}

public extension SCChartPlotStyle {
    static let standard = SCChartPlotStyle()

    /// Creates a card-style plot background suitable for dashboards and inspector views.
    static func card(
        backgroundColor: Color = .secondary,
        backgroundOpacity: Double = 0.12,
        cornerRadius: CGFloat = 12,
        padding: CGFloat = 8,
        clipContent: Bool = true,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0
    ) -> SCChartPlotStyle {
        SCChartPlotStyle(
            backgroundColor: backgroundColor,
            backgroundOpacity: backgroundOpacity,
            cornerRadius: cornerRadius,
            padding: padding,
            clipContent: clipContent,
            borderColor: borderColor,
            borderWidth: borderWidth
        )
    }
}
