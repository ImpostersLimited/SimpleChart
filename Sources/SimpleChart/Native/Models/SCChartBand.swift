//
//  SCChartBand.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

public struct SCChartBand: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let lower: Double
    public let upper: Double
    public let color: Color
    public let opacity: Double
    public let annotation: SCChartAnnotation?

    public init(
        id: String? = nil,
        title: String,
        lower: Double,
        upper: Double,
        color: Color = .accentColor,
        opacity: Double = 0.15,
        annotation: SCChartAnnotation? = nil
    ) {
        let normalizedLower = min(lower, upper)
        let normalizedUpper = max(lower, upper)
        self.id = id ?? title
        self.title = title
        self.lower = normalizedLower
        self.upper = normalizedUpper
        self.color = color
        self.opacity = opacity
        self.annotation = annotation
    }
}

public extension SCChartBand {
    static func make<T: BinaryFloatingPoint>(
        bands: [(String, T, T)],
        color: Color = .accentColor,
        opacity: Double = 0.15
    ) -> [SCChartBand] {
        bands.map { band in
            SCChartBand(
                title: band.0,
                lower: Double(band.1),
                upper: Double(band.2),
                color: color,
                opacity: opacity
            )
        }
    }

    static func make<T: BinaryInteger>(
        bands: [(String, T, T)],
        color: Color = .accentColor,
        opacity: Double = 0.15
    ) -> [SCChartBand] {
        bands.map { band in
            SCChartBand(
                title: band.0,
                lower: Double(band.1),
                upper: Double(band.2),
                color: color,
                opacity: opacity
            )
        }
    }
}
