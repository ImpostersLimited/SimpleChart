//
//  SCChartNavigationCoordinator.swift
//
//
//  Created by Codex on 2026-04-13.
//

import Foundation

enum SCChartNavigationCoordinator {
    static func clampedViewport(
        _ viewport: SCChartViewport,
        zoomBehavior: SCChartZoomBehavior,
        bounds: ClosedRange<Double>
    ) -> SCChartViewport {
        let boundsLength = max(bounds.upperBound - bounds.lowerBound, 0.0001)
        let clampedLength = zoomBehavior.clamped(length: viewport.length, within: boundsLength)
        return SCChartViewport
            .starting(at: viewport.lowerBound, length: clampedLength)
            .clamped(to: bounds)
    }

    static func clampedViewport(
        _ viewport: SCChartTimeViewport,
        zoomBehavior: SCChartZoomBehavior,
        bounds: ClosedRange<Date>
    ) -> SCChartTimeViewport {
        let boundsLength = max(bounds.upperBound.timeIntervalSince(bounds.lowerBound), 0.0001)
        let clampedLength = zoomBehavior.clamped(length: viewport.length, within: boundsLength)
        return SCChartTimeViewport
            .starting(at: viewport.startDate, duration: clampedLength)
            .clamped(to: bounds)
    }

    static func scrollViewport(
        _ viewport: SCChartViewport,
        to lowerBound: Double,
        zoomBehavior: SCChartZoomBehavior,
        bounds: ClosedRange<Double>
    ) -> SCChartViewport {
        clampedViewport(
            SCChartViewport.starting(at: lowerBound, length: viewport.length),
            zoomBehavior: zoomBehavior,
            bounds: bounds
        )
    }

    static func scrollViewport(
        _ viewport: SCChartTimeViewport,
        to startDate: Date,
        zoomBehavior: SCChartZoomBehavior,
        bounds: ClosedRange<Date>
    ) -> SCChartTimeViewport {
        clampedViewport(
            SCChartTimeViewport.starting(at: startDate, duration: viewport.length),
            zoomBehavior: zoomBehavior,
            bounds: bounds
        )
    }

    static func zoomViewport(
        _ viewport: SCChartViewport,
        magnification: Double,
        center: Double? = nil,
        zoomBehavior: SCChartZoomBehavior,
        bounds: ClosedRange<Double>
    ) -> SCChartViewport {
        clampedViewport(
            viewport.zoomed(
                by: zoomBehavior.adjustedMagnification(from: magnification),
                centeredAt: center,
                within: bounds
            ),
            zoomBehavior: zoomBehavior,
            bounds: bounds
        )
    }

    static func zoomViewport(
        _ viewport: SCChartTimeViewport,
        magnification: Double,
        center: Date? = nil,
        zoomBehavior: SCChartZoomBehavior,
        bounds: ClosedRange<Date>
    ) -> SCChartTimeViewport {
        clampedViewport(
            viewport.zoomed(
                by: zoomBehavior.adjustedMagnification(from: magnification),
                centeredAt: center,
                within: bounds
            ),
            zoomBehavior: zoomBehavior,
            bounds: bounds
        )
    }
}
