//
//  SCChartValueFormat.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

public enum SCChartNumericValueFormat: Equatable, Codable {
    case automatic
    case compact
    case currency(code: String, precision: Int = 0)
    case percent(precision: Int = 0)
    case number(precision: Int = 0)

    public func string(from value: Double) -> String {
        switch self {
        case .automatic:
            return value.formatted()
        case .compact:
            return value.formatted(.number.notation(.compactName))
        case let .currency(code, precision):
            return value.formatted(
                .currency(code: code).precision(.fractionLength(max(precision, 0)))
            )
        case let .percent(precision):
            return value.formatted(
                .percent.precision(.fractionLength(max(precision, 0)))
            )
        case let .number(precision):
            return value.formatted(
                .number.precision(.fractionLength(max(precision, 0)))
            )
        }
    }
}

public enum SCChartDateValueFormat: Equatable, Codable {
    case automatic
    case date
    case time
    case monthDay
    case monthYear
    case hourMinute

    public func string(from date: Date) -> String {
        switch self {
        case .automatic:
            return date.formatted(date: .abbreviated, time: .omitted)
        case .date:
            return date.formatted(date: .complete, time: .omitted)
        case .time:
            return date.formatted(date: .omitted, time: .shortened)
        case .monthDay:
            return date.formatted(.dateTime.month(.abbreviated).day())
        case .monthYear:
            return date.formatted(.dateTime.month(.abbreviated).year())
        case .hourMinute:
            return date.formatted(.dateTime.hour().minute())
        }
    }
}
