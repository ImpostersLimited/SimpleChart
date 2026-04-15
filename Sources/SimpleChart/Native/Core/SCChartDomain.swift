//
//  SCChartDomain.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

/// Describes the resolved y-axis domain for a chart, including the raw data bounds used to derive it.
public struct SCChartDomain: Equatable, Codable {
    public let lowerBound: Double
    public let upperBound: Double
    public let actualLowerBound: Double
    public let actualUpperBound: Double

    /// Creates a chart domain from explicit rendered bounds and the underlying unpadded data bounds.
    public init(
        lowerBound: Double,
        upperBound: Double,
        actualLowerBound: Double,
        actualUpperBound: Double
    ) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.actualLowerBound = actualLowerBound
        self.actualUpperBound = actualUpperBound
    }

    /// The closed numeric range used when applying the domain to a Swift Charts y-scale.
    public var yScaleRange: ClosedRange<Double> {
        lowerBound...upperBound
    }

    /// Resolves a padded domain from a flat array of values.
    public static func make(
        values: [Double],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        let actualLower = lowerOverride ?? values.min() ?? 0
        let actualUpper = upperOverride ?? values.max() ?? 0
        return make(
            actualLower: actualLower,
            actualUpper: actualUpper,
            baseZero: baseZero,
            paddingRatio: paddingRatio
        )
    }

    /// Resolves a padded domain from floating-point values.
    public static func make<T: BinaryFloatingPoint>(
        values: [T],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            values: values.map(Double.init),
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Resolves a padded domain from integer values.
    public static func make<T: BinaryInteger>(
        values: [T],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            values: values.map(Double.init),
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Resolves a padded domain from paired lower and upper value collections.
    public static func make(
        lowerValues: [Double],
        upperValues: [Double],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        let actualLower = lowerOverride ?? lowerValues.min() ?? 0
        let actualUpper = upperOverride ?? upperValues.max() ?? 0
        return make(
            actualLower: actualLower,
            actualUpper: actualUpper,
            baseZero: baseZero,
            paddingRatio: paddingRatio
        )
    }

    /// Derives a domain from matching floating-point lower and upper bound collections.
    public static func make<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        lowerValues: [T],
        upperValues: [U],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            lowerValues: lowerValues.map(Double.init),
            upperValues: upperValues.map(Double.init),
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Derives a domain from matching integer lower and upper bound collections.
    public static func make<T: BinaryInteger, U: BinaryInteger>(
        lowerValues: [T],
        upperValues: [U],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            lowerValues: lowerValues.map(Double.init),
            upperValues: upperValues.map(Double.init),
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Convenience alias for `make(values:)` when callers want an auto-derived domain.
    public static func auto(
        values: [Double],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            values: values,
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Convenience alias for `make(values:)` with floating-point input.
    public static func auto<T: BinaryFloatingPoint>(
        values: [T],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            values: values,
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Convenience alias for `make(values:)` with integer input.
    public static func auto<T: BinaryInteger>(
        values: [T],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            values: values,
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Convenience alias for auto-deriving a domain from existing chart points.
    public static func auto(
        points: [SCChartPoint],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            values: points.map(\.value),
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Convenience alias for auto-deriving a domain from explicit lower and upper floating-point bounds.
    public static func auto(
        lowerValues: [Double],
        upperValues: [Double],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            lowerValues: lowerValues,
            upperValues: upperValues,
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Convenience alias for auto-deriving a domain from matching floating-point lower and upper bound collections.
    public static func auto<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(
        lowerValues: [T],
        upperValues: [U],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            lowerValues: lowerValues,
            upperValues: upperValues,
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Convenience alias for auto-deriving a domain from matching integer lower and upper bound collections.
    public static func auto<T: BinaryInteger, U: BinaryInteger>(
        lowerValues: [T],
        upperValues: [U],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            lowerValues: lowerValues,
            upperValues: upperValues,
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Convenience alias for auto-deriving a domain from existing range points.
    public static func auto(
        points: [SCChartRangePoint],
        baseZero: Bool = false,
        lowerOverride: Double? = nil,
        upperOverride: Double? = nil,
        paddingRatio: Double = 0.03
    ) -> SCChartDomain {
        make(
            lowerValues: points.map(\.lower),
            upperValues: points.map(\.upper),
            baseZero: baseZero,
            lowerOverride: lowerOverride,
            upperOverride: upperOverride,
            paddingRatio: paddingRatio
        )
    }

    /// Creates a fixed domain without applying automatic padding.
    public static func fixed(_ range: ClosedRange<Double>) -> SCChartDomain {
        SCChartDomain(
            lowerBound: range.lowerBound,
            upperBound: range.upperBound,
            actualLowerBound: range.lowerBound,
            actualUpperBound: range.upperBound
        )
    }

    private static func make(
        actualLower: Double,
        actualUpper: Double,
        baseZero: Bool,
        paddingRatio: Double
    ) -> SCChartDomain {
        let baseZeroEnabled = baseZero && actualLower >= 0
        let spread = actualUpper - actualLower

        if baseZeroEnabled {
            let upperBound = spread == 0 ? actualUpper * 1.03 : actualUpper + (spread * paddingRatio)
            return SCChartDomain(
                lowerBound: 0,
                upperBound: upperBound,
                actualLowerBound: 0,
                actualUpperBound: actualUpper
            )
        }

        let lowerBound = spread == 0 ? actualLower * 0.97 : actualLower - (spread * paddingRatio)
        let upperBound = spread == 0 ? actualUpper * 1.03 : actualUpper + (spread * paddingRatio)

        return SCChartDomain(
            lowerBound: lowerBound,
            upperBound: upperBound,
            actualLowerBound: actualLower,
            actualUpperBound: actualUpper
        )
    }
}
