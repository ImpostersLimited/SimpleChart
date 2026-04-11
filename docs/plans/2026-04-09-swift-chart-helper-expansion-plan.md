# Swift Chart Helper Expansion Plan

**Date:** 2026-04-09
**Project:** `SimpleChart`
**Status:** In progress

## Goal

Expand the native Swift Charts-first API so common charts can be built from primitive arrays and simple tuples, while adding a first composition layer for multi-series lines and reference lines.

## Scope

This pass targets helper-style ergonomics, not full Swift Charts feature parity.

Planned additions:

- primitive-array and labeled-value builders for `SCChartPoint`
- range tuple builders for `SCChartRangePoint`
- `SCChartDomain` convenience presets such as auto/fixed
- `SCChartSeriesStyle` and `SCChartAxesStyle` presets
- convenience initializers on native chart wrappers
- multi-series native line chart support
- reference-line helpers for thresholds and averages

Not in scope:

- full mark-level customization parity with Swift Charts
- selection/scrolling APIs
- custom axis mark builders
- date-axis specialization

## Execution order

1. Add shared helper models and presets
2. Add convenience initializers to existing native wrappers
3. Add multi-series line and reference-line composition helpers
4. Add tests for helper builders and wrapper convenience surface
5. Update README and changelog
6. Verify with `swift build` and `swift test`

## Review

- This plan intentionally extends the current native wrapper architecture instead of replacing it.
- The helper layer should remain opinionated and concise so the package stays easier to use than raw Swift Charts for common cases.
