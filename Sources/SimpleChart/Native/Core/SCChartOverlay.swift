//
//  SCChartOverlay.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

/// Describes reusable overlay content that can be layered onto a composed chart.
public enum SCChartOverlay: Equatable {
    case referenceLine(SCChartReferenceLine)
    case referenceLines([SCChartReferenceLine])
    case band(SCChartBand)
    case bands([SCChartBand])
    case pointLabels(
        points: [SCChartPoint],
        color: Color = .secondary,
        anchor: SCChartAnnotationAnchor = .top
    )
}

public extension SCChartOverlay {
    var inferredValues: [Double] {
        switch self {
        case let .referenceLine(referenceLine):
            return [referenceLine.value]
        case let .referenceLines(referenceLines):
            return referenceLines.map(\.value)
        case let .band(band):
            return [band.lower, band.upper]
        case let .bands(bands):
            return bands.flatMap { [$0.lower, $0.upper] }
        case let .pointLabels(points, _, _):
            return points.map(\.value)
        }
    }
}
