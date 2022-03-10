//
//  Lerpable.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/9/22.
//

import Foundation

protocol Lerpable: AdditiveArithmetic {
    static func * (lhs: Self, rhs: CGFloat) -> Self
}

extension CGPoint: Lerpable {
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x-rhs.x, y: lhs.y-rhs.y)
    }
    
    public static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x*rhs, y: lhs.y*rhs)
    }
    
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x+rhs.x, y: lhs.y+rhs.y)
    }
}

extension CGFloat: Lerpable { }
