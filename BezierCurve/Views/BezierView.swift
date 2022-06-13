//
//  AnimatablePaths.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/6/22.
//

import Foundation
import SwiftUI

struct BezierCurve: View, Animatable {
    @EnvironmentObject var data: Data
    
    var t: CGFloat
    
    private func getOrigin() -> CGPoint {
        data.points.reduce(CGPoint(x: 0, y: 0), +) / CGFloat(data.points.count)
    }
    
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
    
    private func factorial(n: Int) -> CGFloat {
        guard n != 0 else { return 1 }
        return (1...n).map(CGFloat.init).reduce(1.0, *)
    }
    
    private func bernstein(v: Int, n: Int) -> CGFloat {
        let _v = CGFloat(v)
        let _n = CGFloat(n)
        
        let coef = factorial(n: n) / (factorial(n: v) * factorial(n: n-v))
        
        return coef * pow(t, _v) * pow(1-t, _n-_v)
    }
    
    private func bernsteinSeries() -> [CGPoint] {
        let origin = getOrigin()
        var result: [CGPoint] = [origin]
        
        for i in 0..<data.points.count {
            let frac: CGFloat = bernstein(v: i, n: data.points.count-1)
            result.append((data.points[i]-origin)*frac+result.last!)
        }
        
        return result
    }
    
    private func rectFromPoint(p: CGPoint, size: CGFloat) -> CGRect {
        CGRect(x: p.x-size/2, y: p.y-size/2, width: size, height: size)
    }
    
    func getGesture(_ id: Int) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                data.points[id] = gesture.location
            }
    }
    
    var animatableData: CGFloat {
        get { t }
        set { t = newValue }
    }
    
    var body: some View {
        let colors = (0..<data.points.count).map { i in CGFloat(i)/CGFloat(data.points.count) }
        let lerpPoints: [[CGPoint]] = getLerpPoints(points: data.points, t: t)
        let lerpColors: [[CGFloat]] = getLerpPoints(points: colors, t: t)
        
        let origin = getOrigin()
        
        if data.mode == .vector_expanded || data.mode == .vector_stacked {
            // Vector lines background
            Path { path in
                if data.points.count >= 1 {
                    for p in data.points {
                        path.move(to: origin)
                        path.addLine(to: p)
                    }
                }
            }
            .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [1, 10]))
        }
        
        if data.mode == .vector_expanded {
            ForEach(0..<data.points.count, id: \.self) { i in
                Path { path in
                    path.move(to: origin)
                    path.addLine(to: data.points[i])
                }
                .trim(from: 0, to: bernstein(v: i, n: data.points.count-1))
                .stroke(
                    Color(hue: Double(i)/Double(data.points.count), saturation: 1, brightness: 1),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
            }
        } else if data.mode == .vector_stacked {
            let series: [CGPoint] = bernsteinSeries()
            
            ForEach(0..<data.points.count, id: \.self) { i in
                Path { path in
                    path.move(to: series[i])
                    path.addLine(to: series[i+1])
                }
                .stroke(
                    Color(hue: Double(i)/Double(data.points.count), saturation: 1, brightness: 1),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
            }
        } else if data.mode == .lerps {
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
        }
        
        // Control lines
        Path { path in
            if data.points.count >= 1 {
                path.move(to: data.points[0])
                for p in data.points[1...] {
                    path.addLine(to: p)
                }
            }
        }
        .stroke(.gray, style: StrokeStyle(lineWidth: 4, lineCap: .round))
        
        // Background curve
        Path { path in
            if data.points.count >= 2 {
                path.move(to: data.points[0])
                for _t in 0...Int(CGFloat(data.resolution)) {
                    let s = CGFloat(_t)/CGFloat(data.resolution)
                    path.addLine(to: getLerpPoints(points: data.points, t: s).last![0])
                }
                
                path.addLine(to: data.points.last!)
            }
        }
        .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [10, 20]))
        
        // Foreground curve
        ForEach(0..<Int(t*CGFloat(data.resolution)), id: \.self) { i in
            let s1 = CGFloat(i)/CGFloat(data.resolution)
            let s2 = CGFloat(i+1)/CGFloat(data.resolution)
            Path { path in
                path.move(to: getLerpPoints(points: data.points, t: s1).last![0])
                path.addLine(to: getLerpPoints(points: data.points, t: s2).last![0])
            }
            .stroke(
                Color(hue: getLerpPoints(points: colors, t: s2).last![0], saturation: 1, brightness: 1),
                style: StrokeStyle(lineWidth: 8, lineCap: .round)
            )
        }
        let i = Int(t*CGFloat(data.resolution))
        let s1 = CGFloat(i)/CGFloat(data.resolution)
        Path { path in
            if data.points.count >= 2 {
                path.move(to: getLerpPoints(points: data.points, t: s1).last![0])
                path.addLine(to: lerpPoints.last![0])
            }
        }
        .stroke(
            Color(hue: data.points.count >= 2 ? lerpColors.last![0] : 0, saturation: 1, brightness: 1),
            style: StrokeStyle(lineWidth: 8, lineCap: .round)
        )
        
        if data.mode == .lerps {
            // Lerp anchors
            let flatPoints: [CGPoint] = lerpPoints.flatMap({ e in e })
            let flatColors: [CGFloat] = lerpColors.flatMap({ e in e })
            ForEach(0..<flatPoints.count, id: \.self) { i in
                Path { path in
                    path.addEllipse(in: rectFromPoint(p: flatPoints[i], size: 10))
                }
                .fill(Color(hue: flatColors[i], saturation: 1, brightness: 1))
            }
        }
        
        // Control anchors
        ForEach(0..<data.points.count, id: \.self) { i in
            Path { path in
                path.addEllipse(in: rectFromPoint(p: data.points[i], size: 20))
            }
            .fill(Color(hue: Double(i)/Double(data.points.count), saturation: 1, brightness: 1))
            .gesture(getGesture(i))
        }
    }
}
