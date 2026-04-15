//
//  SCChart3DComposition.swift
//
//
//  Created by Codex on 2026-04-10.
//

import SwiftUI

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
/// Describes the 3D marks that can be combined inside `SCComposedChart3D`.
public enum SCChart3DMark {
    case point([SCChart3DPoint], style: SCChart3DSeriesStyle = .init())
    case rectangle([SCChart3DPoint], style: SCChart3DSeriesStyle = .init())
    case rule([SCChart3DPoint], style: SCChart3DSeriesStyle = .init())
    case surface(
        xTitle: String,
        yTitle: String,
        zTitle: String,
        style: SCChart3DSeriesStyle = .init(),
        function: @Sendable (Double, Double) -> Double
    )
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
/// Bundles 3D marks and camera pose into a reusable composition value.
public struct SCChart3DComposition {
    public let marks: [SCChart3DMark]
    public let pose: SCChart3DPoseStyle

    /// Creates a 3D chart composition from marks and an optional viewing pose.
    public init(
        marks: [SCChart3DMark],
        pose: SCChart3DPoseStyle = .default
    ) {
        self.marks = marks
        self.pose = pose
    }
}
