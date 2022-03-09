//
//  MainView.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/5/22.
//

import SwiftUI

struct MainView: View {
    @Binding var data: Data
    
    var body: some View {
        GeometryReader { geometry in
            BezierCurve(points: $data.points, t: data.t, resolution: data.resolution)
            .animation(data.animation, value: data.t)
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
