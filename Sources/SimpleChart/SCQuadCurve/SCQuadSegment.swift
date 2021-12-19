//
//  SCQuadSegment.swift
//  
//
//  Created by fung on 18/12/2021.
//

import Foundation

@available(iOS 15, macOS 12.0, *)
public struct SCQuadSegment: Codable, Equatable {
    public init(_ p1: Double, _ p2: Double){
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
        
        /*
         var controlPoint = midPoint(p1: p1, p2: p2)
                 let diffY = abs(p2.y - controlPoint.y)
                 
                 if p1.y < p2.y {
                     controlPoint.y += diffY
                 } else if p1.y > p2.y {
                     controlPoint.y -= diffY
                 }
         */
        /*
         if p1 == nil {
             self.p2 = (p_self + p2!) / 2
             self.p1 = p_self
             self.p_self = (self.p1 + self.p2) / 2
             if self.p2 == self.p1 {
                 self.p_control = self.p1
             }
             else {
                 self.p_control = (2*self.p_self) - (self.p1/2) - (self.p2/2)
             }
         }
         else if p2 == nil {
             self.p1 = (p1! + p_self) / 2
             self.p2 = p_self
             self.p_self = (self.p1 + self.p2) / 2
             if self.p2 == self.p1 {
                 self.p_control = self.p1
             }
             else {
                 self.p_control = (2*self.p_self) - (self.p1/2) - (self.p2/2)
             }
         }
         else {
             self.p2 = (p2! + p_self) / 2
             self.p1 = (p1! + p_self) / 2
             self.p_self = p_self
             if self.p2 == self.p1 {
                 self.p_control = self.p1
             }
             else {
                 self.p_control = (2*self.p_self) - (self.p1/2) - (self.p2/2)
             }
             //y1 = 2*yc - y0/2 - y2/2
         }
         */
    }
    let p1: Double
    let p_mid: Double
    let p_control1: Double
    let p_control2: Double
    let p2: Double
    /*
     let p1: Double
     let p_self: Double
     let p_control: Double
     let p2: Double
     */
}
