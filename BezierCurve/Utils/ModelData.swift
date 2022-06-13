//
//  BezierModel.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/5/22.
//

import Foundation
import SwiftUI

enum Mode: Identifiable {
    case lerps, vector_expanded, vector_stacked
    var id: Self { self }
}

class Data: ObservableObject {
    @Published var points: [CGPoint] = []
    @Published var t: CGFloat = 0
    @Published var resolution: Int = 128
    @Published var animation: Animation = .spring(response: 0.5, dampingFraction: 1)
    @Published var placingPoints: Bool = false
    @Published var showVectors: Bool = true
    @Published var mode: Mode = .lerps
}
