//
//  SCComposedChart3D.swift
//
//
//  Created by Codex on 2026-04-10.
//

import Charts
import SwiftUI

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct SCComposedChart3D: View {
    public let composition: SCChart3DComposition

    public init(composition: SCChart3DComposition) {
        self.composition = composition
    }

    public init(
        marks: [SCChart3DMark],
        pose: SCChart3DPoseStyle = .default
    ) {
        self.composition = SCChart3DComposition(marks: marks, pose: pose)
    }

    public var body: some View {
        Chart3D {
            ForEach(Array(composition.marks.enumerated()), id: \.offset) { _, mark in
                chart3DContent(for: mark)
            }
        }
        .chart3DPose(composition.pose.chart3DPose)
    }

    @Chart3DContentBuilder
    private func chart3DContent(for mark: SCChart3DMark) -> some Chart3DContent {
        switch mark {
        case let .point(points, style):
            ForEach(points) { point in
                PointMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y),
                    z: .value("Z", point.z)
                )
                .foregroundStyle(style.color)
                .symbolSize(style.symbolSize)
            }
        case let .rectangle(points, style):
            ForEach(points) { point in
                RectangleMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y),
                    z: .value("Z", point.z)
                )
                .foregroundStyle(style.color)
            }
        case let .rule(points, style):
            ForEach(points) { point in
                RuleMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y),
                    z: .value("Z", point.z)
                )
                .foregroundStyle(style.color)
            }
        case let .surface(xTitle, yTitle, zTitle, style, function):
            SurfacePlot(x: xTitle, y: yTitle, z: zTitle, function: function)
                .foregroundStyle(style.color)
        }
    }
}
