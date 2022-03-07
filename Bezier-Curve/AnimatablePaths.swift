//
//  AnimatablePaths.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/6/22.
//

import Foundation
import SwiftUI

struct Line: Shape {
    var start, end: CGPoint

    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
        get { AnimatablePair(start.animatableData, end.animatableData) }
        set { (start.animatableData, end.animatableData) = (newValue.first, newValue.second) }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
    }
}

struct Circle: Shape {
    var pos: CGPoint
    var size: CGFloat
    
    private func rectFromPoint(p: CGPoint) -> CGRect {
        return CGRect(x: p.x-size/2, y: p.y-size/2, width: size, height: size)
    }
    
    var animatableData: CGPoint.AnimatableData {
        get { pos.animatableData }
        set { pos.animatableData = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addEllipse(in: rectFromPoint(p: pos))
        }
    }
}
