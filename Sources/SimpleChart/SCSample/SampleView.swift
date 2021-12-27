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
                let temp: [SCBarChartData] = [
                    SCBarChartData(0.0),
                    SCBarChartData(1.0),
                    SCBarChartData(2.0),
                    SCBarChartData(1.0),
                    SCBarChartData(4.0),
                    SCBarChartData(3.0),
                    SCBarChartData(2.0),
                    SCBarChartData(3.0),
                    SCBarChartData(5.0),
                    SCBarChartData(3.5)]
                SCBarChart(config: SCBarChartConfig(chartData: temp))
                    .frame(width: 150, height: 150)
                let temp2: [SCHistogramData] = [
                    SCHistogramData(0.0),
                    SCHistogramData(1.0),
                    SCHistogramData(2.0),
                    SCHistogramData(1.0),
                    SCHistogramData(4.0),
                    SCHistogramData(3.0),
                    SCHistogramData(2.0),
                    SCHistogramData(3.0),
                    SCHistogramData(5.0),
                    SCHistogramData(3.5)]
                SCHistogram(config: SCHistogramConfig(chartData: temp2, stroke: true))
                    .frame(width: 150, height: 150)
            }
            HStack {
                let temp3: [SCLineChartData] = [
                    SCLineChartData(0.0),
                    SCLineChartData(9.0),
                    SCLineChartData(1.0),
                    SCLineChartData(1.0),
                    SCLineChartData(4.0),
                    SCLineChartData(7.0),
                    SCLineChartData(2.0),
                    SCLineChartData(3.0),
                    SCLineChartData(10.0),
                    SCLineChartData(0)]
                SCLineChart(config: SCLineChartConfig(chartData: temp3, showInterval: true, showXAxis: true, showYAxis: true, stroke: true))
                    .frame(width: 150, height: 150)
                let temp4: [SCQuadCurveData] = [
                    SCQuadCurveData(0.0),
                    SCQuadCurveData(9.0),
                    SCQuadCurveData(1.0),
                    SCQuadCurveData(1.0),
                    SCQuadCurveData(4.0),
                    SCQuadCurveData(7.0),
                    SCQuadCurveData(2.0),
                    SCQuadCurveData(3.0),
                    SCQuadCurveData(10.0),
                    SCQuadCurveData(9.0)]
                SCQuadCurve(config: SCQuadCurveConfig(chartData: temp4, showInterval: true, color: [.red, .green, .gray], gradientStart: .topLeading, gradientEnd: .bottomTrailing))
                    .frame(width: 150, height: 150)
            }
            HStack{
                let temp5: [SCRangeChartData] = [
                    SCRangeChartData(0.0, 10.0),
                    SCRangeChartData(1.0, 7.0),
                    SCRangeChartData(2.0, 9.0),
                    SCRangeChartData(1.0, 4.0),
                    SCRangeChartData(4.0, 9.0),
                    SCRangeChartData(3.0, 6.0),
                    SCRangeChartData(2.0, 7.0),
                    SCRangeChartData(3.0, 8.0),
                    SCRangeChartData(5.0, 9.0),
                    SCRangeChartData(0.0, 9.0)
                ]
                SCRangeChart(config: SCRangeChartConfig(chartData: temp5))
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
