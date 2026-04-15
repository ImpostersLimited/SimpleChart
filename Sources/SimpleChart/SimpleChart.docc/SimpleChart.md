# ``SimpleChart``

Native Swift Charts-first wrappers and helper types for building bar, line, range, time-series, composed, and interactive charts with a small, reusable API surface.

## Overview

SimpleChart provides ready-made wrappers on top of Swift Charts while also exposing the helper models and interaction state used by those wrappers internally.

Use the package when you want:

- fast wrapper-style chart construction for common chart families
- a helper-first API for points, domains, axes, overlays, and interaction state
- a migration path from the original `SCManager` / `SC*Config` legacy layer

The package is organized around a few core concepts:

- ``SCChartPoint`` and related point models for data input
- ``SCChartSeriesStyle`` and ``SCChartAxesStyle`` for visual configuration
- ``SCChartDomain`` and visible-window helpers such as ``SCChartViewport`` and ``SCChartTimeViewport``
- wrapper families such as ``SCNativeLineChart``, ``SCNativeBarChart``, and ``SCScrollableTimeSeriesChart``

## Start Here

- <doc:GettingStarted>
- <doc:InteractiveCharts>
- <doc:WrapperChooser>
- <doc:LegacyMigration>

## Topics

### Essentials

- <doc:GettingStarted>
- ``SCChartPoint``
- ``SCChartSeriesStyle``
- ``SCChartAxesStyle``
- ``SCChartDomain``

### Wrapper Families

- <doc:WrapperChooser>
- ``SCNativeLineChart``
- ``SCNativeBarChart``
- ``SCNativeRangeChart``
- ``SCNativeTimeSeriesChart``
- ``SCComposedChart``

### Interactive Charts

- <doc:InteractiveCharts>
- ``SCChartSelectionState``
- ``SCChartInspectionOverlay``
- ``SCChartScrollBehavior``
- ``SCChartZoomBehavior``
- ``SCChartGestureConfiguration``
- ``SCChartViewport``
- ``SCChartTimeViewport``
- ``SCScrollableLineChart``
- ``SCScrollableTimeSeriesChart``

### Migration

- <doc:LegacyMigration>
- ``SCManager``
- ``SCLineChart``
- ``SCBarChart``
- ``SCHistogram``
- ``SCQuadCurve``
- ``SCRangeChart``
