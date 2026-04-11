//
//  SCChartAnnotation.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

public enum SCChartAnnotationAnchor: String, Codable, Equatable {
    case top
    case topLeading
    case topTrailing
    case bottom
    case bottomLeading
    case bottomTrailing
    case overlay
}

public enum SCChartAnnotationStyle: String, Codable, Equatable {
    case plain
    case caption
    case badge
}

public struct SCChartAnnotation: Equatable {
    public let text: String
    public let color: Color
    public let backgroundColor: Color?
    public let backgroundOpacity: Double
    public let anchor: SCChartAnnotationAnchor
    public let alignment: Alignment
    public let style: SCChartAnnotationStyle

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
