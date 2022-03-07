//
//  BezierModel.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/5/22.
//

import Foundation
import SwiftUI

struct BezierModel {
    var P0: CGPoint
    var P1: CGPoint
    var C0: CGPoint
    var C1: CGPoint
}

struct Data {
    var properties: BezierModel = BezierModel(P0: CGPoint(x: 100, y: 100), P1: CGPoint(x: 400, y: 400), C0: CGPoint(x: 250, y: 100), C1: CGPoint(x: 250, y: 400))
    var t: CGFloat = 0
    var animation: Animation = .spring(response: 0.5, dampingFraction: 1)
    var defaultAnimation: Animation = .spring(response: 0.5, dampingFraction: 1)
}
