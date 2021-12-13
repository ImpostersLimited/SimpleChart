//
//  SwiftUIView.swift
//  
//
//  Created by fung on 13/12/2021.
//

import SwiftUI

@available(iOS 15, macOS 12.0, *)
struct SCCapsuleView: View {
    
    @State var config: SCChartConfig
    @State var data: SCChartData
    
    public init(_ config: SCChartConfig, _ data: SCChartData){
        self.config = config
        self.data = data
    }
    var body: some View {
        Capsule()
    }
}

@available(iOS 15, macOS 12.0, *)
struct SCCapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        SCCapsuleView(SCChartConfig([SCChartData]()), SCChartData(0.0))
    }
}
