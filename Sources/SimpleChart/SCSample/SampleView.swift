//
//  SwiftUIView.swift
//  
//
//  Created by fung on 27/12/2021.
//

import SwiftUI

private struct SampleView: View {
    var body: some View {
        VStack{
            HStack{
                SCNativeBarChart(
                    points: SCPreviewFixtures.nativeBarPoints,
                    axesStyle: SCPreviewFixtures.nativeAxesStyle,
                    domain: SCChartDomain.make(values: SCPreviewFixtures.nativeBarPoints.map(\.value))
                )
                    .frame(width: 150, height: 150)
                SCNativeHistogramChart(
                    values: SCPreviewFixtures.barValues,
                    binCount: 4,
                    axesStyle: SCPreviewFixtures.nativeAxesStyle
                )
                    .frame(width: 150, height: 150)
            }
            HStack {
                SCNativeLineChart(
                    points: SCPreviewFixtures.nativeLinePoints,
                    seriesStyle: SCChartSeriesStyle(colors: [.blue, .cyan], strokeWidth: 2, showArea: true),
                    axesStyle: SCPreviewFixtures.nativeAxesStyle,
                    domain: SCChartDomain.make(values: SCPreviewFixtures.nativeLinePoints.map(\.value))
                )
                    .frame(width: 150, height: 150)
                SCNativeQuadCurveChart(
                    points: SCPreviewFixtures.nativeQuadPoints,
                    seriesStyle: SCChartSeriesStyle(
                        colors: [.red, .green, .gray],
                        showArea: true,
                        interpolation: .catmullRom,
                        gradientStart: .topLeading,
                        gradientEnd: .bottomTrailing
                    ),
                    axesStyle: SCPreviewFixtures.nativeAxesStyle,
                    domain: SCChartDomain.make(values: SCPreviewFixtures.nativeQuadPoints.map(\.value), paddingRatio: 0.08)
                )
                    .frame(width: 150, height: 150)
            }
            HStack{
                SCNativeRangeChart(
                    points: SCPreviewFixtures.nativeRangePoints,
                    seriesStyle: SCChartSeriesStyle(colors: [.pink], strokeWidth: 2),
                    axesStyle: SCPreviewFixtures.nativeAxesStyle,
                    domain: SCChartDomain.make(
                        lowerValues: SCPreviewFixtures.nativeRangePoints.map(\.lower),
                        upperValues: SCPreviewFixtures.nativeRangePoints.map(\.upper),
                        paddingRatio: 0.08
                    )
                )
                    .frame(width: 150, height: 150)
            }
        }
    }
}

internal struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}
