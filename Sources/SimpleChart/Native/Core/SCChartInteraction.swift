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
    /// The default visible x-domain window used when the chart first appears.
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

/// Configures whether zoom is enabled and how far a chart window may zoom in or out.
public struct SCChartZoomBehavior: Equatable, Codable {
    /// Whether pinch-style zoom interactions should change the visible window.
    public let isEnabled: Bool
    /// The smallest allowed visible-domain length after zooming in.
    public let minimumVisibleLength: Double?
    /// The largest allowed visible-domain length after zooming out.
    public let maximumVisibleLength: Double?
    /// A multiplier applied to gesture magnification deltas before they update the visible window.
    public let sensitivity: Double

    /// Creates a zoom policy with optional minimum/maximum visible lengths.
    ///
    /// - Parameters:
    ///   - isEnabled: Whether zoom gestures should be honored.
    ///   - minimumVisibleLength: The minimum visible-domain length allowed by the policy.
    ///   - maximumVisibleLength: The maximum visible-domain length allowed by the policy.
    ///   - sensitivity: A multiplier that makes the zoom feel slower or faster than the raw gesture delta.
    public init(
        isEnabled: Bool = true,
        minimumVisibleLength: Double? = nil,
        maximumVisibleLength: Double? = nil,
        sensitivity: Double = 1
    ) {
        self.isEnabled = isEnabled
        self.minimumVisibleLength = minimumVisibleLength.map { max($0, 0.0001) }
        self.maximumVisibleLength = maximumVisibleLength.map { max($0, 0.0001) }
        self.sensitivity = max(sensitivity, 0.0001)
    }

    /// A permissive default zoom policy suitable for most scrollable wrappers.
    public static let standard = SCChartZoomBehavior()

    /// Disables zoom-specific behavior while keeping the API surface stable.
    public static let disabled = SCChartZoomBehavior(
        isEnabled: false,
        minimumVisibleLength: nil,
        maximumVisibleLength: nil,
        sensitivity: 1
    )

    func clamped(length: Double, within boundsLength: Double) -> Double {
        let lowerBound = minimumVisibleLength ?? 0.0001
        let upperBound = min(maximumVisibleLength ?? boundsLength, max(boundsLength, 0.0001))
        return min(max(length, lowerBound), max(upperBound, lowerBound))
    }

    func adjustedMagnification(from magnification: Double) -> Double {
        guard magnification.isFinite else { return 1 }
        let delta = (magnification - 1) * sensitivity
        return max(0.0001, 1 + delta)
    }
}

/// Enables or disables selection and scrolling gestures for interactive wrappers.
public struct SCChartGestureConfiguration: Equatable, Codable {
    /// Whether the wrapper should expose selection gestures.
    public let allowsSelection: Bool
    /// Whether the wrapper should expose horizontal scrolling gestures.
    public let allowsScrolling: Bool
    /// Whether the wrapper should expose pinch-style zoom gestures.
    public let allowsZooming: Bool

    /// Creates a gesture policy for wrappers that support selection, scrolling, and zooming.
    public init(
        allowsSelection: Bool = true,
        allowsScrolling: Bool = true,
        allowsZooming: Bool = true
    ) {
        self.allowsSelection = allowsSelection
        self.allowsScrolling = allowsScrolling
        self.allowsZooming = allowsZooming
    }

    private enum CodingKeys: String, CodingKey {
        case allowsSelection
        case allowsScrolling
        case allowsZooming
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let allowsSelection = try container.decode(Bool.self, forKey: .allowsSelection)
        let allowsScrolling = try container.decode(Bool.self, forKey: .allowsScrolling)
        let allowsZooming = try container.decodeIfPresent(Bool.self, forKey: .allowsZooming)
            ?? allowsScrolling
        self.init(
            allowsSelection: allowsSelection,
            allowsScrolling: allowsScrolling,
            allowsZooming: allowsZooming
        )
    }

    /// Enables selection, scrolling, and zooming together.
    public static let interactive = SCChartGestureConfiguration()
    /// Enables selection only.
    public static let selectionOnly = SCChartGestureConfiguration(
        allowsSelection: true,
        allowsScrolling: false,
        allowsZooming: false
    )
    /// Enables scrolling and zooming without selection.
    public static let scrollOnly = SCChartGestureConfiguration(
        allowsSelection: false,
        allowsScrolling: true,
        allowsZooming: true
    )
    /// Disables all interactive gesture handling.
    public static let staticOnly = SCChartGestureConfiguration(
        allowsSelection: false,
        allowsScrolling: false,
        allowsZooming: false
    )
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
