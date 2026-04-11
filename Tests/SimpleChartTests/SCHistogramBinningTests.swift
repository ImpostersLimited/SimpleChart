import XCTest
@testable import SimpleChart

final class SCHistogramBinningTests: XCTestCase {
    func testHistogramBinningProducesExpectedBinCount() {
        let bins = SCHistogramBinning.makeBins(values: [1, 2, 3, 4], binCount: 2)
        XCTAssertEqual(bins.count, 2)
        XCTAssertEqual(bins.map(\.count).reduce(0, +), 4)
    }
}
