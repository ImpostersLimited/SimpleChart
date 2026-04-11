//
//  SCChart3DStyle.swift
//
//
//  Created by Codex on 2026-04-10.
//

import Foundation
import SwiftUI

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public enum SCChart3DPoseStyle: Equatable {
    case `default`
    case front
    case back
    case top
    case bottom
    case left
    case right
    case custom(azimuthDegrees: Double, inclinationDegrees: Double)
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct SCChart3DSeriesStyle: Equatable {
    public let color: Color
    public let symbolSize: CGFloat

    public init(
        color: Color = .accentColor,
        symbolSize: CGFloat = 40
    ) {
        self.color = color
        self.symbolSize = symbolSize
    }
}
