//
//  SCQuadSegment.swift
//  
//
//  Created by fung on 18/12/2021.
//

import Foundation

@available(iOS 15, macOS 12.0, *)
public struct SCQuadSegment: Codable, Equatable {
    public init(_ p1: Double? = nil, _ p_self: Double, _ p2: Double? = nil){
        if p1 == nil {
            self.p2 = (p_self + p2!) / 2
            self.p1 = p_self
            self.p_self = (self.p1 + self.p2) / 2
            self.p_control = (2*self.p_self) - (self.p1/2) - (self.p2/2)
        }
        else if p2 == nil {
            self.p1 = (p1! + p_self) / 2
            self.p2 = p_self
            self.p_self = (self.p1 + self.p2) / 2
            self.p_control = (2*self.p_self) - (self.p1/2) - (self.p2/2)
        }
        else {
            self.p2 = (p2! + p_self) / 2
            self.p1 = (p1! + p_self) / 2
            self.p_self = p_self
            self.p_control = (2*self.p_self) - (self.p1/2) - (self.p2/2)
            //y1 = 2*yc - y0/2 - y2/2
        }
    }
    
    let p1: Double
    let p_self: Double
    let p_control: Double
    let p2: Double
}
