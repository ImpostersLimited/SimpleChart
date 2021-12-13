import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct SimpleChartView: View {
    
    @State var chartData: [SCChartData]
    @State var chartConfig: SCChartConfig
    let baseZero: Bool
    let spacing: Double?
    let width: Double?
    
    public init(_ chartData: [SCChartData], _ baseZero: Bool = false, _ spacing: Double? = nil, _ width: Double? = nil) {
        self.chartData = chartData
        self.baseZero = baseZero
        self.spacing = spacing
        self.width = width
        self.chartConfig = SCChartConfig(chartData, baseZero, spacing, width)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            HStack {
                ForEach(chartData.indices) { index in
                    SCCapsuleView(self.chartConfig, self.chartData[index])
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Capsule().foregroundColor(Color.purple))
                        .foregroundColor(.white)
                }
            }
            .padding(.all, 5)
        }
        .onChange(of: chartData) { newValue in
            self.setConfig(self.chartData, self.baseZero, self.spacing, self.width)
        }
    }
    
    private func setConfig(_ chartData: [SCChartData], _ baseZero: Bool = false, _ spacing: Double? = nil, _ width: Double? = nil){
        let chartConfig = SCChartConfig(chartData, baseZero, spacing, width)
        self.chartConfig = chartConfig
    }
}

@available(iOS 15, macOS 12.0, *)
struct SimpleChartView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleChartView([SCChartData]())
    }
}
