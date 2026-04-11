import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeSectorSelectionTests: XCTestCase {
    func testAnnotationHelpersExposeHelperStyles() {
        let badge = SCChartAnnotation.badge("Goal", color: .blue)
        let caption = SCChartAnnotation.caption("Revenue", color: .secondary)
        let valueLabel = SCChartAnnotation.valueLabel(12.5, format: .currency(code: "USD"))

        XCTAssertEqual(badge.text, "Goal")
        XCTAssertEqual(badge.style, .badge)
        XCTAssertEqual(badge.color, .blue)

        XCTAssertEqual(caption.text, "Revenue")
        XCTAssertEqual(caption.style, .caption)

        XCTAssertTrue(valueLabel.text.contains("12"))
        XCTAssertTrue(valueLabel.text.contains("$"))
        XCTAssertEqual(valueLabel.style, .badge)
        XCTAssertNotNil(valueLabel.backgroundColor)
    }

    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, macCatalyst 17, *)
    func testSelectableSectorAndDonutChartsStoreInteractionConfiguration() {
        var selectionState = SCChartSelectionState()
        let stateBinding = Binding(
            get: { selectionState },
            set: { selectionState = $0 }
        )
        let segments = SCChartSectorSegment.make(segments: [("Free", 12), ("Paid", 5)])

        let sector = SCSelectableSectorChart(
            segments: segments,
            selectionState: stateBinding,
            inspectionOverlay: .callout(anchor: .bottom),
            gestureConfiguration: .interactive
        )
        let donut = SCSelectableDonutChart(
            segments: segments,
            selectionState: stateBinding,
            innerRadiusRatio: 0.55,
            inspectionOverlay: .pointLabel(anchor: .top),
            gestureConfiguration: .selectionOnly
        )

        XCTAssertEqual(sector.segments, segments)
        XCTAssertEqual(sector.inspectionOverlay, .callout(anchor: .bottom))
        XCTAssertEqual(sector.gestureConfiguration, .interactive)

        XCTAssertEqual(donut.segments, segments)
        XCTAssertEqual(donut.innerRadiusRatio, 0.55)
        XCTAssertEqual(donut.inspectionOverlay, .pointLabel(anchor: .top))
        XCTAssertEqual(donut.gestureConfiguration, .selectionOnly)
    }
}
