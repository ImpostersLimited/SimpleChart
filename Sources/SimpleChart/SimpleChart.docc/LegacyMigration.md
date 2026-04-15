# Migrating from the Legacy API

The original `SCManager`, `SC*Config`, and `SC*Data` types are still present for compatibility, but they are deprecated and bridged onto the native Swift Charts-first wrapper layer.

## Migration Direction

The preferred path is:

- `SCLineChart` -> ``SCNativeLineChart``
- `SCBarChart` -> ``SCNativeBarChart``
- `SCHistogram` -> ``SCNativeHistogramChart``
- `SCQuadCurve` -> ``SCNativeQuadCurveChart``
- `SCRangeChart` -> ``SCNativeRangeChart``

## Why Migrate

The native wrapper layer gives you:

- clearer helper models such as ``SCChartPoint`` and ``SCChartDomain``
- stronger interaction support through ``SCChartSelectionState`` and scroll/zoom helpers
- better Xcode symbol docs and DocC organization

## Keep the Migration Incremental

Because the legacy wrappers bridge onto the newer types, you can migrate chart-by-chart instead of rewriting the whole package integration at once.
