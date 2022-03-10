//
//  AnimatablePaths.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/6/22.
//

import Foundation
import SwiftUI

struct BezierCurve: View, Animatable {
    @Binding var points: [CGPoint]
    var t: CGFloat
    var resolution: Int
    
    private func lerp<T: Lerpable>(p0: T, p1: T, t: CGFloat) -> T {
            p0*(1-t)+p1*t
        }
        
        private func multiLerp<T: Lerpable>(points: [T], t: CGFloat) -> [T] {
            zip(points[..<points.count], points[1...]).map { (a, b) in
                lerp(p0: a, p1: b, t: t)
            }
        }
        
        private func getLerpPoints<T: Lerpable>(points: [T], t: CGFloat) -> [[T]] {
            guard points.count >= 2 else { return [[]] }
            
            var buf: [[T]] = []
            var scope: [T] = points
            while true {
                if scope.count == 1 {
                    return buf + [scope]
                }
                let tmp = multiLerp(points: scope, t: t)
                buf += [tmp]
                scope = tmp
            }

            return buf
        }
    
    private func rectFromPoint(p: CGPoint, size: CGFloat) -> CGRect {
        CGRect(x: p.x-size/2, y: p.y-size/2, width: size, height: size)
    }
    
    func getGesture(_ id: Int) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                points[id] = gesture.location
            }
    }
    
    var animatableData: CGFloat {
        get { t }
        set { t = newValue }
    }
    
    var body: some View {
        let colors = (0..<points.count).map { i in CGFloat(i)/CGFloat(points.count) }
        let lerpPoints: [[CGPoint]] = getLerpPoints(points: points, t: t)
        let lerpColors: [[CGFloat]] = getLerpPoints(points: colors, t: t)
        
        // Lerp lines
        Path { path in
            for tier in lerpPoints {
                guard tier.count > 1 else { continue }
                for (a, b) in zip(tier[..<(tier.count)], tier[1...]) {
                    path.move(to: a)
                    path.addLine(to: b)
                }
            }
        }
        .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [1, 10]))
        
        // Control lines
        Path { path in
            if points.count >= 1 {
                path.move(to: points[0])
                for p in points[1...] {
                    path.addLine(to: p)
                }
            }
        }
        .stroke(.gray, style: StrokeStyle(lineWidth: 4, lineCap: .round))
        
        // Background curve
        Path { path in
            if points.count >= 2 {
                path.move(to: points[0])
                for _t in 0...Int(CGFloat(resolution)) {
                    let s = CGFloat(_t)/CGFloat(resolution)
                    path.addLine(to: getLerpPoints(points: points, t: s).last![0])
                }
            
                path.addLine(to: points.last!)
            }
        }
        .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [10, 20]))
        
        // Foreground curve
        ForEach(0..<Int(t*CGFloat(resolution)), id: \.self) { i in
            let s1 = CGFloat(i)/CGFloat(resolution)
            let s2 = CGFloat(i+1)/CGFloat(resolution)
            Path { path in
                path.move(to: getLerpPoints(points: points, t: s1).last![0])
                path.addLine(to: getLerpPoints(points: points, t: s2).last![0])
            }
            .stroke(
                Color(hue: getLerpPoints(points: colors, t: s2).last![0], saturation: 1, brightness: 1),
                style: StrokeStyle(lineWidth: 8, lineCap: .round)
            )
        }
        let i = Int(t*CGFloat(resolution))
        let s1 = CGFloat(i)/CGFloat(resolution)
        Path { path in
            if points.count >= 2 {
                path.move(to: getLerpPoints(points: points, t: s1).last![0])
                path.addLine(to: lerpPoints.last![0])
            }
        }
        .stroke(
            Color(hue: points.count >= 2 ? getLerpPoints(points: colors, t: t).last![0] : 0, saturation: 1, brightness: 1),
            style: StrokeStyle(lineWidth: 8, lineCap: .round)
        )
        
        // Lerp anchors
        let flatPoints: [CGPoint] = lerpPoints.flatMap({ e in e })
        let flatColors: [CGFloat] = lerpColors.flatMap({ e in e })
        ForEach(0..<flatPoints.count, id: \.self) { i in
            Path { path in
                path.addEllipse(in: rectFromPoint(p: flatPoints[i], size: 10))
            }
            .fill(Color(hue: flatColors[i], saturation: 1, brightness: 1))
        }
        
        // Control anchors
        ForEach(0..<points.count, id: \.self) { i in
            Path { path in
                path.addEllipse(in: rectFromPoint(p: points[i], size: 20))
            }
            .fill(Color(hue: Double(i)/Double(points.count), saturation: 1, brightness: 1))
            .gesture(getGesture(i))
        }
    }
}
