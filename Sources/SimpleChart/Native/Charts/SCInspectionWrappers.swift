//
//  SCInspectionWrappers.swift
//
//
//  Created by Codex on 2026-04-10.
//

import SwiftUI

/// A convenience wrapper that presents line-chart selection using the inspector overlay preset.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCInspectorLineChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let gestureConfiguration: SCChartGestureConfiguration
    public let anchor: SCChartAnnotationAnchor
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates an inspector-style line chart with a bound selection.
    public init(
        points: [SCChartPoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        anchor: SCChartAnnotationAnchor = .top,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.referenceLines = referenceLines
        self.gestureConfiguration = gestureConfiguration
        self.anchor = anchor
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCSelectableLineChart(
            points: points,
            selection: $selection,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines,
            inspectionOverlay: .inspector(anchor: anchor),
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }
}

/// A convenience wrapper that presents line-chart selection using crosshair guides.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCCrosshairLineChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let gestureConfiguration: SCChartGestureConfiguration
    public let anchor: SCChartAnnotationAnchor
    public let showsCallout: Bool
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates a crosshair-style line chart with a bound selection.
    public init(
        points: [SCChartPoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        anchor: SCChartAnnotationAnchor = .top,
        showsCallout: Bool = true,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.referenceLines = referenceLines
        self.gestureConfiguration = gestureConfiguration
        self.anchor = anchor
        self.showsCallout = showsCallout
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCSelectableLineChart(
            points: points,
            selection: $selection,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines,
            inspectionOverlay: .crosshair(anchor: anchor, showsCallout: showsCallout),
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }
}

/// A convenience wrapper that presents bar-chart selection using the inspector overlay preset.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCInspectorBarChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let gestureConfiguration: SCChartGestureConfiguration
    public let anchor: SCChartAnnotationAnchor
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates an inspector-style bar chart with a bound selection.
    public init(
        points: [SCChartPoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        anchor: SCChartAnnotationAnchor = .top,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.gestureConfiguration = gestureConfiguration
        self.anchor = anchor
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCSelectableBarChart(
            points: points,
            selection: $selection,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            inspectionOverlay: .inspector(anchor: anchor),
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }
}

/// A convenience wrapper that presents bar-chart selection using crosshair guides.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCCrosshairBarChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let gestureConfiguration: SCChartGestureConfiguration
    public let anchor: SCChartAnnotationAnchor
    public let showsCallout: Bool
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates a crosshair-style bar chart with a bound selection.
    public init(
        points: [SCChartPoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .bar(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        anchor: SCChartAnnotationAnchor = .top,
        showsCallout: Bool = true,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.gestureConfiguration = gestureConfiguration
        self.anchor = anchor
        self.showsCallout = showsCallout
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCSelectableBarChart(
            points: points,
            selection: $selection,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            inspectionOverlay: .crosshair(anchor: anchor, showsCallout: showsCallout),
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }
}

/// A convenience wrapper that presents scatter-chart selection using the inspector overlay preset.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCInspectorScatterChart: View {
    public let points: [SCChartScatterPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let gestureConfiguration: SCChartGestureConfiguration
    public let anchor: SCChartAnnotationAnchor
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates an inspector-style scatter chart with a bound selection.
    public init(
        points: [SCChartScatterPoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .scatter(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        anchor: SCChartAnnotationAnchor = .top,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.gestureConfiguration = gestureConfiguration
        self.anchor = anchor
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCSelectableScatterChart(
            points: points,
            selection: $selection,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            inspectionOverlay: .inspector(anchor: anchor),
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }
}

/// A convenience wrapper that presents scatter-chart selection using crosshair guides.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
public struct SCCrosshairScatterChart: View {
    public let points: [SCChartScatterPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let gestureConfiguration: SCChartGestureConfiguration
    public let anchor: SCChartAnnotationAnchor
    public let showsCallout: Bool
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates a crosshair-style scatter chart with a bound selection.
    public init(
        points: [SCChartScatterPoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .scatter(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        anchor: SCChartAnnotationAnchor = .top,
        showsCallout: Bool = true,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.gestureConfiguration = gestureConfiguration
        self.anchor = anchor
        self.showsCallout = showsCallout
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCSelectableScatterChart(
            points: points,
            selection: $selection,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            inspectionOverlay: .crosshair(anchor: anchor, showsCallout: showsCallout),
            gestureConfiguration: gestureConfiguration,
            yAxisFormat: yAxisFormat
        )
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A time-series wrapper that always shows inspector-style selection callouts.
public struct SCInspectorTimeSeriesChart: View {
    public let points: [SCChartTimePoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let gestureConfiguration: SCChartGestureConfiguration
    public let anchor: SCChartAnnotationAnchor
    public let xAxisFormat: SCChartDateValueFormat
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates an inspector-style time-series wrapper bound directly to an optional selection.
    public init(
        points: [SCChartTimePoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        anchor: SCChartAnnotationAnchor = .top,
        xAxisFormat: SCChartDateValueFormat = .monthDay,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.referenceLines = referenceLines
        self.gestureConfiguration = gestureConfiguration
        self.anchor = anchor
        self.xAxisFormat = xAxisFormat
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCSelectableTimeSeriesChart(
            points: points,
            selection: $selection,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines,
            inspectionOverlay: .inspector(anchor: anchor),
            gestureConfiguration: gestureConfiguration,
            xAxisFormat: xAxisFormat,
            yAxisFormat: yAxisFormat
        )
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
/// A time-series wrapper that always shows crosshair-style selection guides.
public struct SCCrosshairTimeSeriesChart: View {
    public let points: [SCChartTimePoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?
    public let referenceLines: [SCChartReferenceLine]
    public let gestureConfiguration: SCChartGestureConfiguration
    public let anchor: SCChartAnnotationAnchor
    public let showsCallout: Bool
    public let xAxisFormat: SCChartDateValueFormat
    public let yAxisFormat: SCChartNumericValueFormat

    @Binding private var selection: SCChartSelection?

    /// Creates a crosshair-style time-series wrapper bound directly to an optional selection.
    public init(
        points: [SCChartTimePoint],
        selection: Binding<SCChartSelection?>,
        seriesStyle: SCChartSeriesStyle = .line(),
        axesStyle: SCChartAxesStyle = .standard(),
        domain: SCChartDomain? = nil,
        referenceLines: [SCChartReferenceLine] = [],
        gestureConfiguration: SCChartGestureConfiguration = .selectionOnly,
        anchor: SCChartAnnotationAnchor = .top,
        showsCallout: Bool = true,
        xAxisFormat: SCChartDateValueFormat = .monthDay,
        yAxisFormat: SCChartNumericValueFormat = .automatic
    ) {
        self.points = points
        self._selection = selection
        self.seriesStyle = seriesStyle
        self.axesStyle = axesStyle
        self.domain = domain
        self.referenceLines = referenceLines
        self.gestureConfiguration = gestureConfiguration
        self.anchor = anchor
        self.showsCallout = showsCallout
        self.xAxisFormat = xAxisFormat
        self.yAxisFormat = yAxisFormat
    }

    public var body: some View {
        SCSelectableTimeSeriesChart(
            points: points,
            selection: $selection,
            seriesStyle: seriesStyle,
            axesStyle: axesStyle,
            domain: domain,
            referenceLines: referenceLines,
            inspectionOverlay: .crosshair(anchor: anchor, showsCallout: showsCallout),
            gestureConfiguration: gestureConfiguration,
            xAxisFormat: xAxisFormat,
            yAxisFormat: yAxisFormat
        )
    }
}
