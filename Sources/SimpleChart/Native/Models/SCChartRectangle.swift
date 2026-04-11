//
//  SCChartRectangle.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// Represents a rectangle mark bounded by categorical x positions and numeric y bounds.
public struct SCChartRectangle: Identifiable, Equatable {
    public let id: String
    public let xStart: Double
    public let xEnd: Double
    public let yStart: Double
    public let yEnd: Double
    public let color: Color?
    public let annotation: SCChartAnnotation?

    /// Creates a rectangle mark from explicit x/y bounds and optional styling.
    public init(
        id: String? = nil,
        xStart: Double,
        xEnd: Double,
        yStart: Double,
        yEnd: Double,
        color: Color? = nil,
        annotation: SCChartAnnotation? = nil
    ) {
        let normalizedXStart = min(xStart, xEnd)
        let normalizedXEnd = max(xStart, xEnd)
        let normalizedYStart = min(yStart, yEnd)
        let normalizedYEnd = max(yStart, yEnd)

        self.id = id ?? "\(normalizedXStart)-\(normalizedXEnd)-\(normalizedYStart)-\(normalizedYEnd)"
        self.xStart = normalizedXStart
        self.xEnd = normalizedXEnd
        self.yStart = normalizedYStart
        self.yEnd = normalizedYEnd
        self.color = color
        self.annotation = annotation
    }
}

public extension SCChartRectangle {
    static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        rectangles: [(T, T, U, U)],
        colors: [Color] = []
    ) -> [SCChartRectangle] {
        rectangles.enumerated().map { index, rectangle in
            SCChartRectangle(
                id: "rectangle-\(index)",
                xStart: Double(rectangle.0),
                xEnd: Double(rectangle.1),
                yStart: Double(rectangle.2),
                yEnd: Double(rectangle.3),
                color: colors[safe: index]
            )
        }
    }

    static func make<T: BinaryInteger, U: BinaryInteger>(
        rectangles: [(T, T, U, U)],
        colors: [Color] = []
    ) -> [SCChartRectangle] {
        rectangles.enumerated().map { index, rectangle in
            SCChartRectangle(
                id: "rectangle-\(index)",
                xStart: Double(rectangle.0),
                xEnd: Double(rectangle.1),
                yStart: Double(rectangle.2),
                yEnd: Double(rectangle.3),
                color: colors[safe: index]
            )
        }
    }
}
