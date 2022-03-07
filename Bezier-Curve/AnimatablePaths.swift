//
//  AnimatablePaths.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/6/22.
//

import Foundation
import SwiftUI

struct Line: Shape {
    var start1, end1, start2, end2: CGPoint
    var t: CGFloat

    private func lerp(p0: CGPoint, p1: CGPoint, t: CGFloat) -> CGPoint {
        return CGPoint(x: p0.x*(1-t)+p1.x*t, y: p0.y*(1-t)+p1.y*t)
    }
    
    var animatableData: AnimatablePair<AnimatablePair<AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData>, AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData>>, CGFloat> {
        get { AnimatablePair(AnimatablePair(AnimatablePair(start1.animatableData, end1.animatableData), AnimatablePair(start2.animatableData, end2.animatableData)), t) }
        set {
            (start1.animatableData, end1.animatableData) = (newValue.first.first.first, newValue.first.first.second)
            (start2.animatableData, end2.animatableData) = (newValue.first.second.first, newValue.first.second.second)
            t = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: lerp(p0: start1, p1: start2, t: t))
            path.addLine(to: lerp(p0: end1, p1: end2, t: t))
        }
    }
}

struct Circle: Shape {
    var start, end: CGPoint
    var t: CGFloat
    var size: CGFloat
    
    private func lerp(p0: CGPoint, p1: CGPoint, t: CGFloat) -> CGPoint {
        return CGPoint(x: p0.x*(1-t)+p1.x*t, y: p0.y*(1-t)+p1.y*t)
    }
    
    private func rectFromPoint(p: CGPoint) -> CGRect {
        return CGRect(x: p.x-size/2, y: p.y-size/2, width: size, height: size)
    }
    
    var animatableData: AnimatablePair<AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData>, CGFloat> {
        get { AnimatableData(AnimatablePair(start.animatableData, end.animatableData), t) }
        set {
            start.animatableData = newValue.first.first
            end.animatableData   = newValue.first.second
            t = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addEllipse(in: rectFromPoint(p: lerp(p0: start, p1: end, t: t)))
        }
    }
}
