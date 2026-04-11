//
//  SCChartSeriesStyle.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// The interpolation policy used by line- and area-based wrappers.
public enum SCChartInterpolation: String, Codable, Equatable {
    case linear
    case monotone
    case catmullRom
}

/// Shared styling for native series wrappers, including stroke, fill, and interpolation behavior.
public struct SCChartSeriesStyle: Equatable {
    public let colors: [Color]
    public let strokeWidth: CGFloat
    public let markSize: CGFloat
    public let showArea: Bool
    public let strokeOnly: Bool
    public let interpolation: SCChartInterpolation
    public let gradientStart: UnitPoint
    public let gradientEnd: UnitPoint

    /// Creates a reusable series style that can be applied across line-, area-, bar-, range-, and scatter-style wrappers.
    public init(
        colors: [Color] = [.primary],
        strokeWidth: CGFloat = 1,
        markSize: CGFloat = 40,
        showArea: Bool = false,
        strokeOnly: Bool = false,
        interpolation: SCChartInterpolation = .linear,
        gradientStart: UnitPoint = .top,
        gradientEnd: UnitPoint = .bottom
    ) {
        self.colors = colors
        self.strokeWidth = strokeWidth
        self.markSize = markSize
        self.showArea = showArea
        self.strokeOnly = strokeOnly
        self.interpolation = interpolation
        self.gradientStart = gradientStart
        self.gradientEnd = gradientEnd
    }
}

public extension SCChartSeriesStyle {
    /// Returns a standard line style preset with configurable colors, width, and interpolation.
    static func line(
        _ colors: [Color] = [.accentColor],
        strokeWidth: CGFloat = 2,
        interpolation: SCChartInterpolation = .linear
    ) -> SCChartSeriesStyle {
        SCChartSeriesStyle(
            colors: colors,
            strokeWidth: strokeWidth,
            markSize: 40,
            showArea: false,
            strokeOnly: false,
            interpolation: interpolation
        )
    }

    /// Returns an area-chart preset that renders both fill and stroke.
    static func area(
        _ colors: [Color] = [.accentColor, .accentColor.opacity(0.35)],
        strokeWidth: CGFloat = 2,
        interpolation: SCChartInterpolation = .linear
    ) -> SCChartSeriesStyle {
        SCChartSeriesStyle(
            colors: colors,
            strokeWidth: strokeWidth,
            markSize: 40,
            showArea: true,
            strokeOnly: false,
            interpolation: interpolation
        )
    }

    /// Returns a bar-chart preset with a simple foreground style.
    static func bar(
        _ colors: [Color] = [.accentColor]
    ) -> SCChartSeriesStyle {
        SCChartSeriesStyle(colors: colors)
    }

    /// Returns a scatter-chart preset tuned for point size rather than line width.
    static func scatter(
        _ colors: [Color] = [.accentColor],
        size: CGFloat = 40
    ) -> SCChartSeriesStyle {
        SCChartSeriesStyle(
            colors: colors,
            strokeWidth: 1,
            markSize: size,
            showArea: false,
            strokeOnly: false,
            interpolation: .linear
        )
    }

    /// Returns a filled range-chart preset.
    static func rangeFill(
        _ colors: [Color] = [.accentColor]
    ) -> SCChartSeriesStyle {
        SCChartSeriesStyle(colors: colors, strokeOnly: false)
    }

    /// Returns a stroked range-chart preset for rule-style spans.
    static func rangeStroke(
        _ colors: [Color] = [.accentColor],
        width: CGFloat = 3
    ) -> SCChartSeriesStyle {
        SCChartSeriesStyle(colors: colors, strokeWidth: width, markSize: 40, strokeOnly: true)
    }
}
