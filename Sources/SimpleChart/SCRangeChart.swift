import Foundation
import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct SCRangeChart: View {
    
    @State var chartData: [SCRangeChartData]
    @State var chartConfig: SCRangeChartConfig
    
    public init(config: SCRangeChartConfig) {
        self.chartData = config.chartData
        self.chartConfig = config
    }
    
    public var body: some View {
        ZStack{
            GeometryReader { proxy in
                VStack(alignment: .center, spacing: 0, content: {
                    HStack{
                        Spacer().frame(height: 0)
                    }
                    HStack(alignment: .bottom, spacing: chartConfig.spacingFactor*proxy.size.width, content: {
                          ForEach(chartData.indices) { index in
                              SCCapsule(self.chartConfig, self.chartData[index], proxy.size)
                                  .foregroundColor(.white)
                          }
                    })
                })
            }
        }
        .padding(.all, 5)
    }
}

@available(iOS 15, macOS 12.0, *)
public struct SCChart_Previews: PreviewProvider {
    static public var previews: some View {
        let temp: [SCRangeChartData] = [SCRangeChartData(1.0, 9.0), SCRangeChartData(0.0, 10.0), SCRangeChartData(5.0, 6.0)]
        SCRangeChart(config: SCRangeChartConfig(temp))
            .frame(width: 100.0, height: 100.0)
    }
}
