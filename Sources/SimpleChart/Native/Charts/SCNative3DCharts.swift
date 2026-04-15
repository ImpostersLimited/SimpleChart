//
//  SCNative3DCharts.swift
//
//
//  Created by Codex on 2026-04-10.
//

import SwiftUI

#if compiler(>=6.3)
@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
/// A 3D point chart wrapper built on the package's composed 3D mark layer.
public struct SCNative3DPointChart: View {
    public let points: [SCChart3DPoint]
    public let style: SCChart3DSeriesStyle
    public let pose: SCChart3DPoseStyle

    /// Creates a 3D point chart from prebuilt 3D points.
    public init(
        points: [SCChart3DPoint],
        style: SCChart3DSeriesStyle = .init(),
        pose: SCChart3DPoseStyle = .default
    ) {
        self.points = points
        self.style = style
        self.pose = pose
    }

    public var body: some View {
        SCComposedChart3D(
            marks: [.point(points, style: style)],
            pose: pose
        )
    }
}
#endif

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
/// A 3D rectangle chart wrapper built on the package's composed 3D mark layer.
public struct SCNative3DRectangleChart: View {
    public let points: [SCChart3DPoint]
    public let style: SCChart3DSeriesStyle
    public let pose: SCChart3DPoseStyle

    /// Creates a 3D rectangle chart from prebuilt 3D points.
    public init(
        points: [SCChart3DPoint],
        style: SCChart3DSeriesStyle = .init(),
        pose: SCChart3DPoseStyle = .default
    ) {
        self.points = points
        self.style = style
        self.pose = pose
    }

    public var body: some View {
        SCComposedChart3D(
            marks: [.rectangle(points, style: style)],
            pose: pose
        )
    }
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
/// A 3D rule chart wrapper built on the package's composed 3D mark layer.
public struct SCNative3DRuleChart: View {
    public let points: [SCChart3DPoint]
    public let style: SCChart3DSeriesStyle
    public let pose: SCChart3DPoseStyle

    /// Creates a 3D rule chart from prebuilt 3D points.
    public init(
        points: [SCChart3DPoint],
        style: SCChart3DSeriesStyle = .init(),
        pose: SCChart3DPoseStyle = .default
    ) {
        self.points = points
        self.style = style
        self.pose = pose
    }

    public var body: some View {
        SCComposedChart3D(
            marks: [.rule(points, style: style)],
            pose: pose
        )
    }
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
/// A 3D surface chart wrapper that samples a function across the rendered surface.
public struct SCNativeSurfacePlotChart: View {
    public let xTitle: String
    public let yTitle: String
    public let zTitle: String
    public let style: SCChart3DSeriesStyle
    public let pose: SCChart3DPoseStyle
    public let function: @Sendable (Double, Double) -> Double

    /// Creates a 3D surface chart from axis titles, style, and a z-value function.
    public init(
        xTitle: String,
        yTitle: String,
        zTitle: String,
        style: SCChart3DSeriesStyle = .init(),
        pose: SCChart3DPoseStyle = .default,
        function: @escaping @Sendable (Double, Double) -> Double
    ) {
        self.xTitle = xTitle
        self.yTitle = yTitle
        self.zTitle = zTitle
        self.style = style
        self.pose = pose
        self.function = function
    }

    public var body: some View {
        SCComposedChart3D(
            marks: [
                .surface(
                    xTitle: xTitle,
                    yTitle: yTitle,
                    zTitle: zTitle,
                    style: style,
                    function: function
                )
            ],
            pose: pose
        )
    }
}
