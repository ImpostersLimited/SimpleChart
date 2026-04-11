//
//  SCChartInspectionSupport.swift
//
//
//  Created by Codex on 2026-04-09.
//

import SwiftUI

struct SCChartInspectionCallout: View {
    let selection: SCChartSelection
    let valueFormat: SCChartNumericValueFormat

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let seriesName = selection.seriesName, !seriesName.isEmpty {
                Text(seriesName)
                    .font(.caption2.weight(.semibold))
            }

            if let xLabel = selection.xLabel, !xLabel.isEmpty {
                Text(xLabel)
                    .font(.caption2)
            }

            SCChartAnnotationLabelView(
                annotation: .badge(valueFormat.string(from: selection.value), color: .primary)
            )
        }
        .padding(6)
        .background(.background.opacity(0.9), in: RoundedRectangle(cornerRadius: 8))
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
struct SCChartHoverCaptureOverlay: View {
    let plotFrame: CGRect
    let onLocation: (CGPoint) -> Void
    let onEnded: () -> Void

    var body: some View {
        Rectangle()
            .fill(.clear)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        onLocation(value.location)
                    }
                    .onEnded { _ in
                        onEnded()
                    }
            )
#if os(macOS) || targetEnvironment(macCatalyst)
            .onContinuousHover { phase in
                switch phase {
                case let .active(location):
                    onLocation(location)
                case .ended:
                    onEnded()
                }
            }
#endif
    }
}
