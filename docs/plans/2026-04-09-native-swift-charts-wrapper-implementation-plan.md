# Native Swift Charts Wrapper Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace SimpleChart's primary rendering path with a new native Swift Charts wrapper layer, while preserving the legacy `SC*` API through deprecated compatibility adapters.

**Architecture:** Introduce a new `Native` namespace with shared chart models, domain/style types, and per-chart Swift Charts views. Keep the existing public chart/config/data types, but route them through a `LegacyBridge` adapter layer into the new native views and mark the old surface deprecated. Existing custom renderer files remain in the package for compatibility and transition visibility, but are no longer the preferred implementation path.

**Tech Stack:** Swift Package Manager, SwiftUI, Swift Charts, XCTest

---

### Task 1: Raise Package Baselines And Establish Native Module Skeleton

**Files:**
- Modify: `Package.swift`
- Create: `Sources/SimpleChart/Native/Core/SCChartDomain.swift`
- Create: `Sources/SimpleChart/Native/Core/SCChartAxesStyle.swift`
- Create: `Sources/SimpleChart/Native/Core/SCChartSeriesStyle.swift`
- Create: `Sources/SimpleChart/Native/Models/SCChartPoint.swift`
- Create: `Sources/SimpleChart/Native/Models/SCChartRangePoint.swift`
- Create: `Sources/SimpleChart/Native/Models/SCHistogramBin.swift`
- Test: `Tests/SimpleChartTests/SCNativeModelTests.swift`

- [ ] **Step 1: Write the failing native model test**

```swift
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
    }
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `swift test --filter SCNativeModelTests/testChartDomainBaseZeroFromPositiveValuesStartsAtZero`
Expected: FAIL because `SCChartDomain` does not exist yet

- [ ] **Step 3: Raise deployment targets in the package manifest**

Update `Package.swift`:

```swift
platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9),
    .macCatalyst(.v16)
],
```

- [ ] **Step 4: Add the native shared model files**

Implement:

```swift
public struct SCChartPoint: Identifiable, Equatable, Codable {
    public let id: String
    public let xLabel: String?
    public let value: Double
}

public struct SCChartRangePoint: Identifiable, Equatable, Codable {
    public let id: String
    public let xLabel: String?
    public let lower: Double
    public let upper: Double
}
```

Implement `SCChartDomain.make(...)` so domain behavior is centralized instead of repeated across each legacy config type.

- [ ] **Step 5: Run the test to verify it passes**

Run: `swift test --filter SCNativeModelTests/testChartDomainBaseZeroFromPositiveValuesStartsAtZero`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add Package.swift Sources/SimpleChart/Native Tests/SimpleChartTests/SCNativeModelTests.swift
git commit -m "feat: add native chart core models"
```

### Task 2: Build The Native Line Chart First To Lock API Shape

**Files:**
- Create: `Sources/SimpleChart/Native/Charts/SCNativeLineChart.swift`
- Modify: `Sources/SimpleChart/Native/Core/SCChartSeriesStyle.swift`
- Modify: `Sources/SimpleChart/Native/Core/SCChartAxesStyle.swift`
- Test: `Tests/SimpleChartTests/SCNativeLineChartTests.swift`

- [ ] **Step 1: Write the failing line chart construction test**

```swift
import XCTest
import SwiftUI
@testable import SimpleChart

final class SCNativeLineChartTests: XCTestCase {
    func testNativeLineChartCanBeConstructedWithSharedPointModel() {
        let points = [
            SCChartPoint(id: "0", xLabel: "A", value: 1),
            SCChartPoint(id: "1", xLabel: "B", value: 2)
        ]

        _ = SCNativeLineChart(points: points)
    }
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `swift test --filter SCNativeLineChartTests/testNativeLineChartCanBeConstructedWithSharedPointModel`
Expected: FAIL because `SCNativeLineChart` does not exist yet

- [ ] **Step 3: Implement the native line chart**

Use `Charts` and `LineMark`:

```swift
import Charts
import SwiftUI

public struct SCNativeLineChart: View {
    public let points: [SCChartPoint]
    public let seriesStyle: SCChartSeriesStyle
    public let axesStyle: SCChartAxesStyle
    public let domain: SCChartDomain?

    public var body: some View {
        Chart(points) { point in
            LineMark(
                x: .value("Index", point.id),
                y: .value("Value", point.value)
            )
        }
    }
}
```

Then refine:
- axis mark visibility from `axesStyle`
- foreground style from `seriesStyle`
- interpolation hook for later quad-curve reuse
- y-scale domain application from `SCChartDomain`

- [ ] **Step 4: Run the test to verify it passes**

Run: `swift test --filter SCNativeLineChartTests/testNativeLineChartCanBeConstructedWithSharedPointModel`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add Sources/SimpleChart/Native/Charts/SCNativeLineChart.swift Sources/SimpleChart/Native/Core Tests/SimpleChartTests/SCNativeLineChartTests.swift
git commit -m "feat: add native line chart wrapper"
```

### Task 3: Implement Native Bar And Range Charts On The Shared Core

**Files:**
- Create: `Sources/SimpleChart/Native/Charts/SCNativeBarChart.swift`
- Create: `Sources/SimpleChart/Native/Charts/SCNativeRangeChart.swift`
- Test: `Tests/SimpleChartTests/SCNativeBarAndRangeChartTests.swift`

- [ ] **Step 1: Write the failing construction tests**

```swift
final class SCNativeBarAndRangeChartTests: XCTestCase {
    func testNativeBarChartCanBeConstructed() {
        _ = SCNativeBarChart(points: [
            SCChartPoint(id: "0", xLabel: "A", value: 3)
        ])
    }

    func testNativeRangeChartCanBeConstructed() {
        _ = SCNativeRangeChart(points: [
            SCChartRangePoint(id: "0", xLabel: "A", lower: 1, upper: 4)
        ])
    }
}
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `swift test --filter SCNativeBarAndRangeChartTests`
Expected: FAIL because chart types do not exist yet

- [ ] **Step 3: Implement native bar and range chart wrappers**

Use:
- `BarMark` for `SCNativeBarChart`
- `RuleMark` first for `SCNativeRangeChart`

Keep the API shape parallel to `SCNativeLineChart`.

For the range chart, validate whether this form is sufficient:

```swift
RuleMark(
    x: .value("Index", point.id),
    yStart: .value("Lower", point.lower),
    yEnd: .value("Upper", point.upper)
)
```

If capsule-like thickness control is insufficient, note the alternative in code comments and keep the wrapper narrow enough to swap the mark strategy later without breaking the public API.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `swift test --filter SCNativeBarAndRangeChartTests`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add Sources/SimpleChart/Native/Charts/SCNativeBarChart.swift Sources/SimpleChart/Native/Charts/SCNativeRangeChart.swift Tests/SimpleChartTests/SCNativeBarAndRangeChartTests.swift
git commit -m "feat: add native bar and range chart wrappers"
```

### Task 4: Implement Histogram And Quad Curve Semantics In The Native Layer

**Files:**
- Create: `Sources/SimpleChart/Native/Charts/SCNativeHistogramChart.swift`
- Create: `Sources/SimpleChart/Native/Charts/SCNativeQuadCurveChart.swift`
- Create: `Sources/SimpleChart/Native/Core/SCHistogramBinning.swift`
- Test: `Tests/SimpleChartTests/SCHistogramBinningTests.swift`
- Test: `Tests/SimpleChartTests/SCNativeCurveChartTests.swift`

- [ ] **Step 1: Write failing tests for binning and quad-curve construction**

```swift
final class SCHistogramBinningTests: XCTestCase {
    func testHistogramBinningProducesExpectedBinCount() {
        let bins = SCHistogramBinning.makeBins(values: [1, 2, 3, 4], binCount: 2)
        XCTAssertEqual(bins.count, 2)
    }
}

final class SCNativeCurveChartTests: XCTestCase {
    func testNativeQuadCurveChartCanBeConstructed() {
        _ = SCNativeQuadCurveChart(points: [
            SCChartPoint(id: "0", xLabel: "A", value: 1)
        ])
    }
}
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `swift test --filter SCHistogramBinningTests`
Run: `swift test --filter SCNativeCurveChartTests`
Expected: FAIL because the binning utility and quad-curve wrapper do not exist yet

- [ ] **Step 3: Implement deterministic histogram binning**

Keep it simple:

```swift
public enum SCHistogramBinning {
    public static func makeBins(values: [Double], binCount: Int) -> [SCHistogramBin] { ... }
}
```

Then build `SCNativeHistogramChart` with `BarMark` over bins rather than raw values.

- [ ] **Step 4: Implement quad-curve wrapper as a native approximation**

Wrap `SCNativeLineChart` semantics with a chart-specific interpolation setting:

```swift
LineMark(...)
    .interpolationMethod(.catmullRom)
```

If another interpolation mode is visually closer, use that instead and document why.

- [ ] **Step 5: Run the tests to verify they pass**

Run: `swift test --filter SCHistogramBinningTests`
Run: `swift test --filter SCNativeCurveChartTests`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add Sources/SimpleChart/Native/Core/SCHistogramBinning.swift Sources/SimpleChart/Native/Charts/SCNativeHistogramChart.swift Sources/SimpleChart/Native/Charts/SCNativeQuadCurveChart.swift Tests/SimpleChartTests/SCHistogramBinningTests.swift Tests/SimpleChartTests/SCNativeCurveChartTests.swift
git commit -m "feat: add native histogram and quad curve wrappers"
```

### Task 5: Add Legacy Adapters For Old Data And Config Types

**Files:**
- Create: `Sources/SimpleChart/LegacyBridge/SCBarChartLegacyAdapter.swift`
- Create: `Sources/SimpleChart/LegacyBridge/SCHistogramLegacyAdapter.swift`
- Create: `Sources/SimpleChart/LegacyBridge/SCLineChartLegacyAdapter.swift`
- Create: `Sources/SimpleChart/LegacyBridge/SCQuadCurveLegacyAdapter.swift`
- Create: `Sources/SimpleChart/LegacyBridge/SCRangeChartLegacyAdapter.swift`
- Modify: `Sources/SimpleChart/SCManager.swift`
- Test: `Tests/SimpleChartTests/SCLegacyAdapterTests.swift`

- [ ] **Step 1: Write a failing adapter test for one legacy chart family**

```swift
final class SCLegacyAdapterTests: XCTestCase {
    func testLegacyLineConfigMapsToNativePointsAndDomain() {
        let config = SCLineChartConfig(chartData: [SCLineChartData(2), SCLineChartData(4)])
        let adapted = SCLineChartLegacyAdapter.makeNativeConfiguration(from: config)

        XCTAssertEqual(adapted.points.count, 2)
        XCTAssertEqual(adapted.points[0].value, 2)
    }
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `swift test --filter SCLegacyAdapterTests/testLegacyLineConfigMapsToNativePointsAndDomain`
Expected: FAIL because the adapter type does not exist yet

- [ ] **Step 3: Implement per-family adapters**

Each adapter should:
- normalize legacy data into `SCChartPoint` or `SCChartRangePoint`
- centralize legacy config translation into `SCChartDomain`, `SCChartAxesStyle`, and `SCChartSeriesStyle`
- preserve empty-data fallback behavior that currently lives inside legacy config initializers

Do not duplicate domain logic in each adapter. Reuse the shared native domain helpers.

- [ ] **Step 4: Deprecate `SCManager` while keeping it functional**

Add deprecation annotations:

```swift
@available(*, deprecated, message: "Use SCChartPoint and SCChartRangePoint initializers instead.")
public class SCManager { ... }
```

Leave the helpers operational so old callers keep compiling.

- [ ] **Step 5: Run the adapter tests to verify they pass**

Run: `swift test --filter SCLegacyAdapterTests`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add Sources/SimpleChart/LegacyBridge Sources/SimpleChart/SCManager.swift Tests/SimpleChartTests/SCLegacyAdapterTests.swift
git commit -m "feat: add legacy adapters for native charts"
```

### Task 6: Redirect Legacy Public Views To Native Views And Add Deprecations

**Files:**
- Modify: `Sources/SimpleChart/SCBarChart/SCBarChart.swift`
- Modify: `Sources/SimpleChart/SCHistogram/SCHistogram.swift`
- Modify: `Sources/SimpleChart/SCLineChart/SCLineChart.swift`
- Modify: `Sources/SimpleChart/SCQuadCurve/SCQuadCurve.swift`
- Modify: `Sources/SimpleChart/SCRangeChart/SCRangeChart.swift`
- Modify: `Sources/SimpleChart/SCBarChart/SCBarChartConfig.swift`
- Modify: `Sources/SimpleChart/SCHistogram/SCHistogramConfig.swift`
- Modify: `Sources/SimpleChart/SCLineChart/SCLineChartConfig.swift`
- Modify: `Sources/SimpleChart/SCQuadCurve/SCQuadCurveConfig.swift`
- Modify: `Sources/SimpleChart/SCRangeChart/SCRangeChartConfig.swift`
- Modify: `Sources/SimpleChart/SCBarChart/SCBarChartData.swift`
- Modify: `Sources/SimpleChart/SCHistogram/SCHistogramData.swift`
- Modify: `Sources/SimpleChart/SCLineChart/SCLineChartData.swift`
- Modify: `Sources/SimpleChart/SCQuadCurve/SCQuadCurveData.swift`
- Modify: `Sources/SimpleChart/SCRangeChart/SCRangeChartData.swift`
- Optionally modify: `Sources/SimpleChart/SCBarChart/SCBar.swift`
- Optionally modify: `Sources/SimpleChart/SCBarChart/SCBarChartInterval.swift`
- Optionally modify: `Sources/SimpleChart/SCHistogram/SCHistogramBar.swift`
- Optionally modify: `Sources/SimpleChart/SCHistogram/SCHistogramInterval.swift`
- Optionally modify: `Sources/SimpleChart/SCLineChart/SCLine.swift`
- Optionally modify: `Sources/SimpleChart/SCLineChart/SCLineChartInterval.swift`
- Optionally modify: `Sources/SimpleChart/SCQuadCurve/SCCurve.swift`
- Optionally modify: `Sources/SimpleChart/SCQuadCurve/SCQuadCurveInterval.swift`
- Optionally modify: `Sources/SimpleChart/SCQuadCurve/SCQuadSegment.swift`
- Optionally modify: `Sources/SimpleChart/SCRangeChart/SCCapsule.swift`
- Optionally modify: `Sources/SimpleChart/SCRangeChart/SCRangeChartInterval.swift`
- Test: `Tests/SimpleChartTests/SCLegacyViewBridgeTests.swift`

- [ ] **Step 1: Write a failing test for legacy view construction after redirect**

```swift
final class SCLegacyViewBridgeTests: XCTestCase {
    func testLegacyLineChartStillConstructsFromLegacyConfig() {
        let config = SCLineChartConfig(chartData: [SCLineChartData(1), SCLineChartData(2)])
        _ = SCLineChart(config: config)
    }
}
```

- [ ] **Step 2: Run the test to verify the bridging path is not complete**

Run: `swift test --filter SCLegacyViewBridgeTests`
Expected: FAIL if redirect plumbing is still incomplete

- [ ] **Step 3: Redirect each legacy public chart view**

Refactor `SCLineChart`, `SCBarChart`, `SCHistogram`, `SCQuadCurve`, and `SCRangeChart` so their `body` returns the native wrapper using the corresponding adapter output.

Pattern:

```swift
@available(*, deprecated, message: "Use SCNativeLineChart instead.")
public struct SCLineChart: View {
    @State var chartConfig: SCLineChartConfig

    public var body: some View {
        SCNativeLineChart(configuration: SCLineChartLegacyAdapter.makeNativeConfiguration(from: chartConfig))
    }
}
```

- [ ] **Step 4: Mark legacy data/config/view types deprecated**

Use targeted replacement guidance in messages, not generic "deprecated" messages.

- [ ] **Step 5: Mark old custom renderer helper files as deprecated-only where possible**

If helpers are public, add deprecation annotations.
If helpers are internal-only and unused after redirect, leave them in place with a short "legacy renderer retained for backward compatibility transition" comment rather than deleting them.

- [ ] **Step 6: Run the legacy bridge tests to verify they pass**

Run: `swift test --filter SCLegacyViewBridgeTests`
Expected: PASS

- [ ] **Step 7: Run the full test suite**

Run: `swift test`
Expected: PASS

- [ ] **Step 8: Commit**

```bash
git add Sources/SimpleChart/SCBarChart Sources/SimpleChart/SCHistogram Sources/SimpleChart/SCLineChart Sources/SimpleChart/SCQuadCurve Sources/SimpleChart/SCRangeChart Tests/SimpleChartTests/SCLegacyViewBridgeTests.swift
git commit -m "refactor: bridge legacy chart views to native wrappers"
```

### Task 7: Update Documentation, Samples, And Test Coverage Baseline

**Files:**
- Modify: `README.md`
- Modify: `Sources/SimpleChart/SCSample/SampleView.swift`
- Modify: `Tests/SimpleChartTests/SimpleChartTests.swift`
- Optionally create: `Tests/SimpleChartTests/SCCompatibilitySmokeTests.swift`

- [ ] **Step 1: Replace the placeholder top-level test file**

Remove the empty example test from `Tests/SimpleChartTests/SimpleChartTests.swift` and replace it with either:
- a small compatibility smoke test, or
- a file-level comment pointing to the new focused test files if the placeholder file becomes unnecessary

- [ ] **Step 2: Update sample usage to show the new preferred API**

Refactor `Sources/SimpleChart/SCSample/SampleView.swift` so the sample demonstrates:
- native bar chart
- native line chart
- native histogram
- native quad curve
- native range chart

Keep one small compatibility example only if it helps document migration.

- [ ] **Step 3: Rewrite the README around the new API**

The README should:
- state the new minimum supported OS versions
- introduce the native-first API first
- explain that the old API remains available but deprecated
- include a migration section from `SCManager`/legacy config objects to native models and views

- [ ] **Step 4: Run the full test suite**

Run: `swift test`
Expected: PASS

- [ ] **Step 5: Build a final package status check**

Run: `swift build`
Expected: BUILD SUCCEEDED

- [ ] **Step 6: Commit**

```bash
git add README.md Sources/SimpleChart/SCSample/SampleView.swift Tests/SimpleChartTests
git commit -m "docs: document native chart API and migration path"
```

### Task 8: Final Verification And Release-Readiness Pass

**Files:**
- Modify: `tasks/todo.md`
- Review: `docs/plans/2026-04-09-native-swift-charts-wrapper-design.md`
- Review: `docs/plans/2026-04-09-native-swift-charts-wrapper-implementation-plan.md`

- [ ] **Step 1: Run the package tests from a clean pass**

Run: `swift test`
Expected: PASS

- [ ] **Step 2: Run a build verification**

Run: `swift build`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Review deprecation coverage**

Manually verify that all of the following are deprecated with targeted guidance:
- `SCManager`
- `SC*ChartData`
- `SC*ChartConfig`
- `SC*Chart` legacy public views

- [ ] **Step 4: Review the README migration narrative**

Confirm the README clearly answers:
- what is the new API
- what still works from the old API
- what changed in platform support
- how to migrate existing callers

- [ ] **Step 5: Update the working todo review section**

Add implementation outcome notes, test results, and any intentional follow-up work left for later.

- [ ] **Step 6: Commit**

```bash
git add tasks/todo.md docs/plans/2026-04-09-native-swift-charts-wrapper-implementation-plan.md
git commit -m "chore: finalize native chart migration plan"
```

## Plan Notes

- The plan intentionally locks the native shared model before chart family expansion so the package does not repeat the current per-family config duplication.
- `SCNativeLineChart` is the first vertical slice because it validates Swift Charts integration, shared styling, and domain handling with minimal chart-specific complexity.
- The range and quad-curve wrappers are expected to be semantic approximations of the current custom rendering, not pixel-identical ports.
- Existing custom renderer helper files remain in the package even if they stop being the active rendering path.
