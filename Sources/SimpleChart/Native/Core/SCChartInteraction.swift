//
//  SCChartInteraction.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Mutable selection state that can be stored outside a chart wrapper and rebound later.
public struct SCChartSelectionState: Equatable {
    /// The currently selected chart element, if any.
    public var selection: SCChartSelection?

    /// Creates selection state with an optional active selection.
    public init(selection: SCChartSelection? = nil) {
        self.selection = selection
    }

    /// Returns `true` when the chart currently has a selected point or bar.
    public var hasSelection: Bool {
        selection != nil
    }
}

/// The inspection UI mode used by selectable and hoverable wrappers.
public enum SCChartInspectionOverlay: Equatable, Codable {
    case automatic(anchor: SCChartAnnotationAnchor = .top)
    case hidden
    case pointLabel(anchor: SCChartAnnotationAnchor = .top)
    case callout(anchor: SCChartAnnotationAnchor = .top)
    case crosshair(anchor: SCChartAnnotationAnchor = .top, showsCallout: Bool = true)
    case inspector(anchor: SCChartAnnotationAnchor = .top)

    /// The preferred annotation anchor used for the overlay's value presentation.
    public var anchor: SCChartAnnotationAnchor {
        switch self {
        case let .automatic(anchor),
             let .pointLabel(anchor),
             let .callout(anchor),
             let .inspector(anchor):
            return anchor
        case let .crosshair(anchor, _):
            return anchor
        case .hidden:
            return .top
        }
    }

    /// Whether the overlay should render a callout-style value summary.
    public var showsCallout: Bool {
        switch self {
        case .automatic, .callout, .inspector:
            return true
        case let .crosshair(_, showsCallout):
            return showsCallout
        case .hidden, .pointLabel:
            return false
        }
    }

    /// Whether the overlay should render crosshair guide rules.
    public var showsCrosshair: Bool {
        switch self {
        case .crosshair:
            return true
        case .automatic, .hidden, .pointLabel, .callout, .inspector:
            return false
        }
    }

    /// Whether the overlay should render any visible inspection UI.
    public var isVisible: Bool {
        self != .hidden
    }
}

/// Scroll-window behavior shared by scrollable wrappers.
public struct SCChartScrollBehavior: Equatable, Codable {
    public let visibleDomain: SCChartVisibleDomain

    /// Creates a scroll behavior from a visible-domain window description.
    public init(visibleDomain: SCChartVisibleDomain) {
        self.visibleDomain = visibleDomain
    }

    /// Creates a continuously scrollable behavior from an explicit visible domain.
    public static func continuous(_ visibleDomain: SCChartVisibleDomain) -> SCChartScrollBehavior {
        SCChartScrollBehavior(visibleDomain: visibleDomain)
    }

    /// Creates a time-window behavior using seconds as the visible span.
    public static func timeWindow(seconds: TimeInterval) -> SCChartScrollBehavior {
        SCChartScrollBehavior(visibleDomain: .seconds(seconds))
    }

    /// Creates a time-window behavior using minutes as the visible span.
    public static func timeWindow(minutes: Double) -> SCChartScrollBehavior {
        SCChartScrollBehavior(visibleDomain: .minutes(minutes))
    }

    /// Creates a time-window behavior using hours as the visible span.
    public static func timeWindow(hours: Double) -> SCChartScrollBehavior {
        SCChartScrollBehavior(visibleDomain: .hours(hours))
    }

    /// Creates a time-window behavior using days as the visible span.
    public static func timeWindow(days: Double) -> SCChartScrollBehavior {
        SCChartScrollBehavior(visibleDomain: .days(days))
    }

    /// Returns an analytics-oriented scrolling preset based on visible point count.
    public static func analytics(points count: Int = 14) -> SCChartScrollBehavior {
        SCChartScrollBehavior(visibleDomain: .analytics(points: count))
    }

    /// Returns a finance-oriented scrolling preset based on visible trading days.
    public static func finance(tradingDays count: Int = 5) -> SCChartScrollBehavior {
        SCChartScrollBehavior(visibleDomain: .finance(tradingDays: count))
    }
}

/// Enables or disables selection and scrolling gestures for interactive wrappers.
public struct SCChartGestureConfiguration: Equatable, Codable {
    public let allowsSelection: Bool
    public let allowsScrolling: Bool

    /// Creates a gesture policy for wrappers that support selection and scrolling.
    public init(
        allowsSelection: Bool = true,
        allowsScrolling: Bool = true
    ) {
        self.allowsSelection = allowsSelection
        self.allowsScrolling = allowsScrolling
    }

    public static let interactive = SCChartGestureConfiguration()
    public static let selectionOnly = SCChartGestureConfiguration(allowsSelection: true, allowsScrolling: false)
    public static let scrollOnly = SCChartGestureConfiguration(allowsSelection: false, allowsScrolling: true)
    public static let staticOnly = SCChartGestureConfiguration(allowsSelection: false, allowsScrolling: false)
}

/// Lightweight hover state that can be bridged to and from a concrete chart selection.
public struct SCChartHoverState: Equatable {
    public let seriesName: String?
    public let xLabel: String?
    public let value: Double

    /// Creates hover state from explicit series, label, and value metadata.
    public init(
        seriesName: String? = nil,
        xLabel: String? = nil,
        value: Double
    ) {
        self.seriesName = seriesName
        self.xLabel = xLabel
        self.value = value
    }

    /// Creates hover state from an existing chart selection.
    public init(selection: SCChartSelection) {
        self.init(
            seriesName: selection.seriesName,
            xLabel: selection.xLabel,
            value: selection.value
        )
    }

    /// Converts hover state back into the shared selection model used by inspection wrappers.
    public var selection: SCChartSelection {
        SCChartSelection(
            seriesName: seriesName,
            xLabel: xLabel,
            value: value
        )
    }
}
