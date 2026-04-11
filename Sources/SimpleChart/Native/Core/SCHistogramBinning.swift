//
//  SCHistogramBinning.swift
//
//
//  Created by Codex on 2026-04-09.
//

import Foundation

public enum SCHistogramBinning {
    public static func makeBins(values: [Double], binCount: Int) -> [SCHistogramBin] {
        guard !values.isEmpty else { return [] }

        let safeBinCount = max(1, binCount)
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 0

        guard minValue != maxValue else {
            return [
                SCHistogramBin(
                    id: "0",
                    lowerBound: minValue,
                    upperBound: maxValue,
                    count: values.count
                )
            ]
        }

        let width = (maxValue - minValue) / Double(safeBinCount)
        var counts = Array(repeating: 0, count: safeBinCount)

        for value in values {
            let rawIndex = Int(((value - minValue) / width).rounded(.down))
            let clampedIndex = min(max(rawIndex, 0), safeBinCount - 1)
            counts[clampedIndex] += 1
        }

        return counts.enumerated().map { index, count in
            let lowerBound = minValue + (Double(index) * width)
            let upperBound = index == safeBinCount - 1 ? maxValue : lowerBound + width

            return SCHistogramBin(
                id: "\(index)",
                lowerBound: lowerBound,
                upperBound: upperBound,
                count: count
            )
        }
    }
}
