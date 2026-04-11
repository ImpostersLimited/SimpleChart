import XCTest
@testable import SimpleChart

final class SCNativeModelTests: XCTestCase {
    func testChartDomainBaseZeroFromPositiveValuesStartsAtZero() {
        let domain = SCChartDomain.make(
            values: [1, 3, 5],
            baseZero: true
        )

        XCTAssertEqual(domain.lowerBound, 0)
        XCTAssertGreaterThan(domain.upperBound, 5)
        XCTAssertEqual(domain.actualLowerBound, 0)
        XCTAssertEqual(domain.actualUpperBound, 5)
    }

    func testRangePointNormalizesBounds() {
        let point = SCChartRangePoint(id: "0", lower: 4, upper: 1)

        XCTAssertEqual(point.lower, 1)
        XCTAssertEqual(point.upper, 4)
    }

    func testChartPointBuilderCreatesIndexedLabelsFromPrimitiveValues() {
        let points = SCChartPoint.make(values: [2, 5, 7], labels: ["Jan", "Feb", "Mar"])

        XCTAssertEqual(points.map(\.id), ["0", "1", "2"])
        XCTAssertEqual(points.map(\.xLabel), ["Jan", "Feb", "Mar"])
        XCTAssertEqual(points.map(\.value), [2, 5, 7])
    }

    func testRangePointBuilderCreatesNormalizedPointsFromTuples() {
        let points = SCChartRangePoint.make(ranges: [(9, 1), (3, 5)], labels: ["Mon", "Tue"])

        XCTAssertEqual(points.map(\.xLabel), ["Mon", "Tue"])
        XCTAssertEqual(points[0].lower, 1)
        XCTAssertEqual(points[0].upper, 9)
        XCTAssertEqual(points[1].lower, 3)
        XCTAssertEqual(points[1].upper, 5)
    }

    func testChartDomainAutoFromPointsUsesPointValues() {
        let points = SCChartPoint.make(values: [4, 8, 10])
        let domain = SCChartDomain.auto(points: points, baseZero: true)

        XCTAssertEqual(domain.lowerBound, 0)
        XCTAssertEqual(domain.actualUpperBound, 10)
    }

    func testReferenceLineAverageHelperComputesMeanValue() {
        let points = SCChartPoint.make(values: [2, 4, 6])
        let referenceLine = SCChartReferenceLine.average(of: points)

        XCTAssertEqual(referenceLine?.title, "Average")
        XCTAssertEqual(referenceLine?.value, 4)
    }
}
