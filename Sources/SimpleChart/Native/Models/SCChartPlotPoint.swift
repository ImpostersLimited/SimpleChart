//
//  SCChartPlotPoint.swift
//
//
//  Created by Codex on 2026-04-10.
//

import Foundation

public struct SCChartPlotPoint: Identifiable, Equatable {
    public let id: String
    public let x: Double
    public let y: Double
    public let seriesName: String?

    public init(
        id: String? = nil,
        x: Double,
        y: Double,
        seriesName: String? = nil
    ) {
        self.id = id ?? "\(x)-\(y)-\(seriesName ?? "")"
        self.x = x
        self.y = y
        self.seriesName = seriesName
    }
}

public struct SCChartPlotSpan: Identifiable, Equatable {
    public let id: String
    public let xStart: Double
    public let xEnd: Double
    public let y: Double
    public let seriesName: String?

    public init(
        id: String? = nil,
        xStart: Double,
        xEnd: Double,
        y: Double,
        seriesName: String? = nil
    ) {
        let normalizedXStart = min(xStart, xEnd)
        let normalizedXEnd = max(xStart, xEnd)
        self.id = id ?? "\(normalizedXStart)-\(normalizedXEnd)-\(y)-\(seriesName ?? "")"
        self.xStart = normalizedXStart
        self.xEnd = normalizedXEnd
        self.y = y
        self.seriesName = seriesName
    }
}

public struct SCChartPlotRange: Identifiable, Equatable {
    public let id: String
    public let x: Double
    public let yStart: Double
    public let yEnd: Double
    public let seriesName: String?

    public init(
        id: String? = nil,
        x: Double,
        yStart: Double,
        yEnd: Double,
        seriesName: String? = nil
    ) {
        let normalizedYStart = min(yStart, yEnd)
        let normalizedYEnd = max(yStart, yEnd)
        self.id = id ?? "\(x)-\(normalizedYStart)-\(normalizedYEnd)-\(seriesName ?? "")"
        self.x = x
        self.yStart = normalizedYStart
        self.yEnd = normalizedYEnd
        self.seriesName = seriesName
    }
}

public struct SCChartPlotRectangle: Identifiable, Equatable {
    public let id: String
    public let xStart: Double
    public let xEnd: Double
    public let yStart: Double
    public let yEnd: Double
    public let seriesName: String?

    public init(
        id: String? = nil,
        xStart: Double,
        xEnd: Double,
        yStart: Double,
        yEnd: Double,
        seriesName: String? = nil
    ) {
        let normalizedXStart = min(xStart, xEnd)
        let normalizedXEnd = max(xStart, xEnd)
        let normalizedYStart = min(yStart, yEnd)
        let normalizedYEnd = max(yStart, yEnd)

        self.id = id ?? "\(normalizedXStart)-\(normalizedXEnd)-\(normalizedYStart)-\(normalizedYEnd)-\(seriesName ?? "")"
        self.xStart = normalizedXStart
        self.xEnd = normalizedXEnd
        self.yStart = normalizedYStart
        self.yEnd = normalizedYEnd
        self.seriesName = seriesName
    }
}

public extension SCChartPlotPoint {
    static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        points: [(T, U)],
        seriesName: String? = nil
    ) -> [SCChartPlotPoint] {
        points.enumerated().map { index, point in
            SCChartPlotPoint(
                id: "plot-point-\(index)",
                x: Double(point.0),
                y: Double(point.1),
                seriesName: seriesName
            )
        }
    }

    static func make<T: BinaryInteger, U: BinaryInteger>(
        points: [(T, U)],
        seriesName: String? = nil
    ) -> [SCChartPlotPoint] {
        points.enumerated().map { index, point in
            SCChartPlotPoint(
                id: "plot-point-\(index)",
                x: Double(point.0),
                y: Double(point.1),
                seriesName: seriesName
            )
        }
    }

    static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        xValues: [T],
        yValues: [U],
        seriesName: String? = nil
    ) -> [SCChartPlotPoint] {
        zip(xValues, yValues).enumerated().map { index, pair in
            SCChartPlotPoint(
                id: "plot-point-\(index)",
                x: Double(pair.0),
                y: Double(pair.1),
                seriesName: seriesName
            )
        }
    }
}

public extension SCChartPlotSpan {
    static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        spans: [(T, T, U)],
        seriesName: String? = nil
    ) -> [SCChartPlotSpan] {
        spans.enumerated().map { index, span in
            SCChartPlotSpan(
                id: "plot-span-\(index)",
                xStart: Double(span.0),
                xEnd: Double(span.1),
                y: Double(span.2),
                seriesName: seriesName
            )
        }
    }

    static func make<T: BinaryInteger, U: BinaryInteger>(
        spans: [(T, T, U)],
        seriesName: String? = nil
    ) -> [SCChartPlotSpan] {
        spans.enumerated().map { index, span in
            SCChartPlotSpan(
                id: "plot-span-\(index)",
                xStart: Double(span.0),
                xEnd: Double(span.1),
                y: Double(span.2),
                seriesName: seriesName
            )
        }
    }
}

public extension SCChartPlotRange {
    static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        ranges: [(T, U, U)],
        seriesName: String? = nil
    ) -> [SCChartPlotRange] {
        ranges.enumerated().map { index, range in
            SCChartPlotRange(
                id: "plot-range-\(index)",
                x: Double(range.0),
                yStart: Double(range.1),
                yEnd: Double(range.2),
                seriesName: seriesName
            )
        }
    }

    static func make<T: BinaryInteger, U: BinaryInteger>(
        ranges: [(T, U, U)],
        seriesName: String? = nil
    ) -> [SCChartPlotRange] {
        ranges.enumerated().map { index, range in
            SCChartPlotRange(
                id: "plot-range-\(index)",
                x: Double(range.0),
                yStart: Double(range.1),
                yEnd: Double(range.2),
                seriesName: seriesName
            )
        }
    }
}

public extension SCChartPlotRectangle {
    static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        rectangles: [(T, T, U, U)],
        seriesName: String? = nil
    ) -> [SCChartPlotRectangle] {
        rectangles.enumerated().map { index, rectangle in
            SCChartPlotRectangle(
                id: "plot-rectangle-\(index)",
                xStart: Double(rectangle.0),
                xEnd: Double(rectangle.1),
                yStart: Double(rectangle.2),
                yEnd: Double(rectangle.3),
                seriesName: seriesName
            )
        }
    }

    static func make<T: BinaryInteger, U: BinaryInteger>(
        rectangles: [(T, T, U, U)],
        seriesName: String? = nil
    ) -> [SCChartPlotRectangle] {
        rectangles.enumerated().map { index, rectangle in
            SCChartPlotRectangle(
                id: "plot-rectangle-\(index)",
                xStart: Double(rectangle.0),
                xEnd: Double(rectangle.1),
                yStart: Double(rectangle.2),
                yEnd: Double(rectangle.3),
                seriesName: seriesName
            )
        }
    }
}
