//
//  SCChartAnnotation.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// Positions annotation content relative to the mark or overlay it decorates.
public enum SCChartAnnotationAnchor: String, Codable, Equatable {
    case top
    case topLeading
    case topTrailing
    case bottom
    case bottomLeading
    case bottomTrailing
    case overlay
}

/// Controls the visual treatment used when rendering an annotation label.
public enum SCChartAnnotationStyle: String, Codable, Equatable {
    case plain
    case caption
    case badge
}

/// Describes reusable annotation content for composed charts, overlays, and inspection UI.
public struct SCChartAnnotation: Equatable {
    public let text: String
    public let color: Color
    public let backgroundColor: Color?
    public let backgroundOpacity: Double
    public let anchor: SCChartAnnotationAnchor
    public let alignment: Alignment
    public let style: SCChartAnnotationStyle

    /// Creates a reusable annotation description from explicit text, colors, and placement.
    public init(
        text: String,
        color: Color = .secondary,
        backgroundColor: Color? = nil,
        backgroundOpacity: Double = 0.12,
        anchor: SCChartAnnotationAnchor = .top,
        alignment: Alignment = .center,
        style: SCChartAnnotationStyle = .plain
    ) {
        self.text = text
        self.color = color
        self.backgroundColor = backgroundColor
        self.backgroundOpacity = backgroundOpacity
        self.anchor = anchor
        self.alignment = alignment
        self.style = style
    }
}

public extension SCChartAnnotation {
    /// Creates a caption-style annotation tuned for reference lines.
    static func lineLabel(
        _ text: String,
        color: Color = .secondary,
        anchor: SCChartAnnotationAnchor = .topLeading,
        alignment: Alignment = .leading
    ) -> SCChartAnnotation {
        SCChartAnnotation(
            text: text,
            color: color,
            anchor: anchor,
            alignment: alignment,
            style: .caption
        )
    }

    /// Creates a badge-style callout suitable for hover and selection summaries.
    static func callout(
        _ text: String,
        color: Color = .secondary,
        backgroundColor: Color? = .secondary,
        backgroundOpacity: Double = 0.12,
        anchor: SCChartAnnotationAnchor = .top,
        alignment: Alignment = .center
    ) -> SCChartAnnotation {
        SCChartAnnotation(
            text: text,
            color: color,
            backgroundColor: backgroundColor,
            backgroundOpacity: backgroundOpacity,
            anchor: anchor,
            alignment: alignment,
            style: .badge
        )
    }

    /// Creates a pill-shaped badge annotation.
    static func badge(
        _ text: String,
        color: Color = .primary,
        backgroundColor: Color? = .secondary,
        backgroundOpacity: Double = 0.12,
        anchor: SCChartAnnotationAnchor = .top,
        alignment: Alignment = .center
    ) -> SCChartAnnotation {
        SCChartAnnotation(
            text: text,
            color: color,
            backgroundColor: backgroundColor,
            backgroundOpacity: backgroundOpacity,
            anchor: anchor,
            alignment: alignment,
            style: .badge
        )
    }

    /// Creates a lightweight caption annotation.
    static func caption(
        _ text: String,
        color: Color = .secondary,
        anchor: SCChartAnnotationAnchor = .top,
        alignment: Alignment = .center
    ) -> SCChartAnnotation {
        SCChartAnnotation(
            text: text,
            color: color,
            anchor: anchor,
            alignment: alignment,
            style: .caption
        )
    }

    /// Formats a numeric value and returns it as a badge-style annotation.
    static func valueLabel(
        _ value: Double,
        format: SCChartNumericValueFormat = .automatic,
        color: Color = .primary,
        backgroundColor: Color? = .secondary,
        backgroundOpacity: Double = 0.12,
        anchor: SCChartAnnotationAnchor = .top,
        alignment: Alignment = .center
    ) -> SCChartAnnotation {
        .badge(
            format.string(from: value),
            color: color,
            backgroundColor: backgroundColor,
            backgroundOpacity: backgroundOpacity,
            anchor: anchor,
            alignment: alignment
        )
    }
}

struct SCChartAnnotationLabelView: View {
    let annotation: SCChartAnnotation

    var body: some View {
        switch annotation.style {
        case .plain:
            Text(annotation.text)
                .font(.caption2)
                .foregroundStyle(annotation.color)
        case .caption:
            Text(annotation.text)
                .font(.caption2)
                .foregroundStyle(annotation.color)
        case .badge:
            Text(annotation.text)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(annotation.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    (annotation.backgroundColor ?? .secondary).opacity(annotation.backgroundOpacity),
                    in: Capsule()
                )
        }
    }
}
