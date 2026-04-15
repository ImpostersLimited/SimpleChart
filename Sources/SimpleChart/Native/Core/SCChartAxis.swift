//
//  SCChartAxis.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// Places an explicit axis title and marks on a specific edge of the chart.
public enum SCChartAxisPosition: String, Codable, Equatable {
    case automatic
    case leading
    case trailing
    case top
    case bottom
}

/// Describes where axis-mark values should come from when building Swift Charts axes.
public enum SCChartAxisValueSource: Equatable {
    case automatic(desiredCount: Int? = nil)
    case integers([Int])
    case doubles([Double])
    case strings([String])
    case dates([Date])
}

/// Configures the marks rendered for a single chart axis.
public struct SCChartAxisMarks: Equatable {
    public let desiredCount: Int
    public let valueSource: SCChartAxisValueSource
    public let showGrid: Bool
    public let showTicks: Bool
    public let showLabels: Bool
    public let lineWidth: CGFloat
    public let lineColor: Color
    public let labelColor: Color

    /// Creates an axis-mark configuration with optional fixed values and styling.
    public init(
        desiredCount: Int = 3,
        valueSource: SCChartAxisValueSource = .automatic(),
        showGrid: Bool = false,
        showTicks: Bool = false,
        showLabels: Bool = false,
        lineWidth: CGFloat = 0.5,
        lineColor: Color = .secondary,
        labelColor: Color = .secondary
    ) {
        self.desiredCount = max(desiredCount, 0)
        self.valueSource = valueSource
        self.showGrid = showGrid
        self.showTicks = showTicks
        self.showLabels = showLabels
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.labelColor = labelColor
    }
}

/// Describes a fully configured x- or y-axis, including title, placement, and mark styling.
public struct SCChartAxis: Equatable {
    public let isVisible: Bool
    public let title: String
    public let titleColor: Color
    public let titleFont: Font
    public let position: SCChartAxisPosition
    public let marks: SCChartAxisMarks

    /// Creates a chart axis from explicit visibility, title, and mark configuration.
    public init(
        isVisible: Bool = false,
        title: String = "",
        titleColor: Color = .primary,
        titleFont: Font = .body,
        position: SCChartAxisPosition = .automatic,
        marks: SCChartAxisMarks = SCChartAxisMarks()
    ) {
        self.isVisible = isVisible
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.position = position
        self.marks = marks
    }
}

public extension SCChartAxis {
    static let hidden = SCChartAxis()

    /// Creates a visible bottom x-axis with the supplied title and mark styling.
    static func x(
        title: String = "",
        titleColor: Color = .primary,
        titleFont: Font = .body,
        desiredCount: Int = 3,
        valueSource: SCChartAxisValueSource = .automatic(),
        showGrid: Bool = false,
        showTicks: Bool = true,
        showLabels: Bool = true,
        lineWidth: CGFloat = 0.5,
        lineColor: Color = .secondary,
        labelColor: Color = .secondary
    ) -> SCChartAxis {
        SCChartAxis(
            isVisible: true,
            title: title,
            titleColor: titleColor,
            titleFont: titleFont,
            position: .bottom,
            marks: SCChartAxisMarks(
                desiredCount: desiredCount,
                valueSource: valueSource,
                showGrid: showGrid,
                showTicks: showTicks,
                showLabels: showLabels,
                lineWidth: lineWidth,
                lineColor: lineColor,
                labelColor: labelColor
            )
        )
    }

    /// Creates a visible y-axis with the supplied title, placement, and mark styling.
    static func y(
        title: String = "",
        titleColor: Color = .primary,
        titleFont: Font = .body,
        desiredCount: Int = 3,
        valueSource: SCChartAxisValueSource = .automatic(),
        showGrid: Bool = false,
        showTicks: Bool = true,
        showLabels: Bool = true,
        lineWidth: CGFloat = 0.5,
        lineColor: Color = .secondary,
        labelColor: Color = .secondary,
        position: SCChartAxisPosition = .leading
    ) -> SCChartAxis {
        SCChartAxis(
            isVisible: true,
            title: title,
            titleColor: titleColor,
            titleFont: titleFont,
            position: position,
            marks: SCChartAxisMarks(
                desiredCount: desiredCount,
                valueSource: valueSource,
                showGrid: showGrid,
                showTicks: showTicks,
                showLabels: showLabels,
                lineWidth: lineWidth,
                lineColor: lineColor,
                labelColor: labelColor
            )
        )
    }
}
