//
//  SCQuadSegment.swift
//  
//
//  Created by fung on 18/12/2021.
//

import Foundation

//@available(iOS 15, macOS 12.0, *)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
internal struct SCQuadSegment: Codable, Equatable {
    internal init(_ p1: Double, _ p2: Double){
        self.p1 = p1
        self.p2 = p2
        self.p_mid = (p1+p2)/2
        
        var con1 = (p1+self.p_mid)/2
        let diff1 = p1-con1
        if self.p_mid < p1 {
            con1 += diff1
        }
        else if self.p_mid > p1 {
            con1 -= diff1
        }
        
        var con2 = (p2+self.p_mid)/2
        let diff2 = p2-con2
        if self.p_mid < p2 {
            con2 += diff2
        }
        else if self.p_mid > p2 {
            con2 -= diff2
        }
        self.p_control1 = con1
        self.p_control2 = con2
    }
    let p1: Double
    let p_mid: Double
    let p_control1: Double
    let p_control2: Double
    let p2: Double
}
