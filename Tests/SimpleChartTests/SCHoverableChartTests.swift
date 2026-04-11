import XCTest
import SwiftUI
@testable import SimpleChart

final class SCHoverableChartTests: XCTestCase {
    func testHoverStateBridgesToSelection() {
        let selection = SCChartSelection(seriesName: "Revenue", xLabel: "Jan", value: 12)
        let hover = SCChartHoverState(selection: selection)

        XCTAssertEqual(hover.seriesName, "Revenue")
        XCTAssertEqual(hover.xLabel, "Jan")
        XCTAssertEqual(hover.value, 12)
        XCTAssertEqual(hover.selection, selection)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testHoverableWrappersStoreInspectionConfiguration() {
        var hoverState: SCChartHoverState?
        let hoverBinding = Binding(
            get: { hoverState },
            set: { hoverState = $0 }
        )

        let linePoints = SCChartPoint.make(labeledValues: [("Mon", 12), ("Tue", 18)])
        let scatterPoints = SCChartScatterPoint.make(labeledPoints: [("A", 1.5, 2.5), ("B", 3.0, 4.0)])

        let line = SCHoverableLineChart(
            points: linePoints,
            hoverState: hoverBinding,
            inspectionOverlay: .callout(anchor: .bottom),
            yAxisFormat: .currency(code: "USD")
        )
        let bar = SCHoverableBarChart(
            points: linePoints,
            hoverState: hoverBinding,
            inspectionOverlay: .pointLabel(anchor: .topTrailing),
            yAxisFormat: .number(precision: 0)
        )
        let scatter = SCHoverableScatterChart(
            points: scatterPoints,
            hoverState: hoverBinding,
            inspectionOverlay: .automatic(anchor: .topLeading),
            yAxisFormat: .compact
        )

        XCTAssertEqual(line.points, linePoints)
        XCTAssertEqual(line.inspectionOverlay, .callout(anchor: .bottom))
        XCTAssertEqual(line.yAxisFormat, .currency(code: "USD"))

        XCTAssertEqual(bar.points, linePoints)
        XCTAssertEqual(bar.inspectionOverlay, .pointLabel(anchor: .topTrailing))
        XCTAssertEqual(bar.yAxisFormat, .number(precision: 0))

        XCTAssertEqual(scatter.points, scatterPoints)
        XCTAssertEqual(scatter.inspectionOverlay, .automatic(anchor: .topLeading))
        XCTAssertEqual(scatter.yAxisFormat, .compact)
    }
}
