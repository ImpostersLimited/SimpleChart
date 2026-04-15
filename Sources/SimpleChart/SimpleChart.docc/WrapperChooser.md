# Choosing a Wrapper

Choose a ready-made wrapper first. Reach for the helper layer directly only when you are composing multiple mark types or sharing configuration across many charts.

## Common Cases

- Use ``SCNativeLineChart`` for one categorical line or area series.
- Use ``SCNativeBarChart`` for single-series category comparisons.
- Use ``SCNativeRangeChart`` when each x-position has lower and upper bounds.
- Use ``SCNativeTimeSeriesChart`` for date-based lines without interaction.
- Use ``SCComposedChart`` when you need mixed marks, overlays, or reusable compositions.

## Interactive Variants

- Use ``SCSelectableLineChart`` / ``SCSelectableBarChart`` / ``SCSelectableScatterChart`` for point selection.
- Use ``SCHoverableLineChart`` / ``SCHoverableBarChart`` / ``SCHoverableScatterChart`` for pointer-driven inspection.
- Use ``SCScrollableLineChart`` and ``SCScrollableTimeSeriesChart`` for navigable x-domain windows.

## When to Use the Helper Layer

Use the helper types directly when you want to:

- reuse marks and overlays through ``SCChartComposition``
- manage visible windows through ``SCChartViewport`` or ``SCChartTimeViewport``
- share styling and scale logic via ``SCChartSeriesStyle``, ``SCChartAxesStyle``, and ``SCChartScale``
