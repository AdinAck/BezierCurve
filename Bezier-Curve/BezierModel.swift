//
//  BezierModel.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/5/22.
//

import Foundation
import SwiftUI

struct Data {
    var points: [CGPoint] = []
    var t: CGFloat = 0
    var resolution: Int = 128
    var animation: Animation = .spring(response: 0.5, dampingFraction: 1)
    var dragAnimation: Animation = .spring(response: 1, dampingFraction: 1)
    var defaultDragAnimation: Animation = .spring(response: 1, dampingFraction: 1)
    var placingPoints: Bool = false
}
