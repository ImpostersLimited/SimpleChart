//
//  SCNativeSectorCharts.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Charts
import SwiftUI

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A sector chart wrapper for the first-party `SectorMark` surface.
public struct SCNativeSectorChart: View {
    public let segments: [SCChartSectorSegment]
    public let palette: [Color]

    /// Creates a sector chart from prebuilt segment models.
    public init(
        segments: [SCChartSectorSegment],
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.segments = segments
        self.palette = palette
    }

    /// Creates a sector chart from floating-point `(title, value)` tuples.
    public init<T: BinaryFloatingPoint>(
        segments: [(String, T)],
        colors: [Color] = [],
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.init(
            segments: SCChartSectorSegment.make(segments: segments, colors: colors),
            palette: palette
        )
    }

    /// Creates a sector chart from integer `(title, value)` tuples.
    public init<T: BinaryInteger>(
        segments: [(String, T)],
        colors: [Color] = [],
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.init(
            segments: SCChartSectorSegment.make(segments: segments, colors: colors),
            palette: palette
        )
    }

    public var body: some View {
        Chart(Array(segments.enumerated()), id: \.element.id) { index, segment in
            SectorMark(
                angle: .value("Value", segment.value),
                innerRadius: .ratio(0)
            )
            .foregroundStyle(segment.color ?? palette[index % max(palette.count, 1)])
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A donut chart wrapper for the first-party `SectorMark` surface.
public struct SCNativeDonutChart: View {
    public let segments: [SCChartSectorSegment]
    public let innerRadiusRatio: Double
    public let palette: [Color]

    /// Creates a donut chart from prebuilt segment models.
    public init(
        segments: [SCChartSectorSegment],
        innerRadiusRatio: Double = 0.6,
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.segments = segments
        self.innerRadiusRatio = innerRadiusRatio
        self.palette = palette
    }

    /// Creates a donut chart from floating-point `(title, value)` tuples.
    public init<T: BinaryFloatingPoint>(
        segments: [(String, T)],
        innerRadiusRatio: Double = 0.6,
        colors: [Color] = [],
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.init(
            segments: SCChartSectorSegment.make(segments: segments, colors: colors),
            innerRadiusRatio: innerRadiusRatio,
            palette: palette
        )
    }

    /// Creates a donut chart from integer `(title, value)` tuples.
    public init<T: BinaryInteger>(
        segments: [(String, T)],
        innerRadiusRatio: Double = 0.6,
        colors: [Color] = [],
        palette: [Color] = [.accentColor, .blue, .orange, .green, .pink, .purple]
    ) {
        self.init(
            segments: SCChartSectorSegment.make(segments: segments, colors: colors),
            innerRadiusRatio: innerRadiusRatio,
            palette: palette
        )
    }

    public var body: some View {
        Chart(Array(segments.enumerated()), id: \.element.id) { index, segment in
            SectorMark(
                angle: .value("Value", segment.value),
                innerRadius: .ratio(innerRadiusRatio)
            )
            .foregroundStyle(segment.color ?? palette[index % max(palette.count, 1)])
        }
    }
}
