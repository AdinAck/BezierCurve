//
//  MainView.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/5/22.
//

import SwiftUI

struct MainView: View {
    
//    @Binding var properties: BezierModel
//    @Binding var t: CGFloat
//    @Binding var animation: Animation
    @Binding var data: Data
    
    @State private var location: CGPoint = CGPoint(x: 0, y: 0)
    @State private var pointSize: CGFloat = 20
    
    var lerp0: CGPoint { lerp(p0: data.properties.P0, p1: data.properties.C0, t: data.t) }
    var lerp1: CGPoint { lerp(p0: data.properties.C0, p1: data.properties.C1, t: data.t) }
    var lerp2: CGPoint { lerp(p0: data.properties.C1, p1: data.properties.P1, t: data.t) }
    var lerp3: CGPoint { lerp(p0: lerp0, p1: lerp1, t: data.t) }
    var lerp4: CGPoint { lerp(p0: lerp1, p1: lerp2, t: data.t) }
    var lerp5: CGPoint { lerp(p0: lerp3, p1: lerp4, t: data.t) }
    
    func getGesture(id: Int) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                switch id {
                case 0:
                    data.properties.P0 = gesture.location
                case 1:
                    data.properties.C0 = gesture.location
                case 2:
                    data.properties.P1 = gesture.location
                case 3:
                    data.properties.C1 = gesture.location
                default:
                    data.properties.P0 = gesture.location
                }
            }
    }
    
    /**
     Adapted from https://stackoverflow.com/questions/1906511/how-to-find-the-distance-between-two-cg-points
     */
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    private func lerp(p0: CGPoint, p1: CGPoint, t: CGFloat) -> CGPoint {
        return CGPoint(x: p0.x*(1-t)+p1.x*t, y: p0.y*(1-t)+p1.y*t)
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            // Curves
            Group {
                // Control line 0
                Path { path in
                    path.move(to: data.properties.P0)
                    path.addLine(to: data.properties.C0)
                }
                .stroke(.gray, style: StrokeStyle(lineWidth: 4, lineCap: .round))

                // Control line 1
                Path { path in
                    path.move(to: data.properties.P1)
                    path.addLine(to: data.properties.C1)
                }
                .stroke(.gray, style: StrokeStyle(lineWidth: 4, lineCap: .round))

                // Middle line
                Path { path in
                    path.move(to: data.properties.C0)
                    path.addLine(to: data.properties.C1)
                }
                .stroke(.gray, style: StrokeStyle(lineWidth: 4, lineCap: .round))

                // Lerps
                Group {
                    // Lerp 0-1
                    Line(start: lerp0, end: lerp1)
                    .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [5, 10]))

                    // Lerp 1-2
                    Line(start: lerp1, end: lerp2)
                    .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [5, 10]))

                    // Lerp 3-4
                    Line(start: lerp3, end: lerp4)
                    .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [5, 10]))
                }
                .animation(data.animation, value: data.t)

                // Background curve
                Path { path in
                    path.move(to: data.properties.P0)
                    path.addCurve(
                        to: data.properties.P1,
                        control1: data.properties.C0,
                        control2: data.properties.C1
                    )

                }
                .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [10, 20]))
                .opacity(0.5)

                // Foreground curve
                Path { path in
                    path.move(to: data.properties.P0)
                    path.addCurve(
                        to: data.properties.P1,
                        control1: data.properties.C0,
                        control2: data.properties.C1
                    )

                }
                .trim(from: 0, to: data.t)
                .stroke(.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .animation(data.animation, value: data.t)
            }
            
            // Lerp points
            Group {
                // Lerp 0
                Circle(pos: lerp0, size: pointSize/2)
                .fill(.orange)
                
                // Lerp 1
                Circle(pos: lerp1, size: pointSize/2)
                .fill(.indigo)
                
                // Lerp 2
                Circle(pos: lerp2, size: pointSize/2)
                .fill(.purple)
                
                // Lerp 3
                Circle(pos: lerp3, size: pointSize/2)
                .fill(.yellow)
                
                // Lerp 4
                Circle(pos: lerp4, size: pointSize/2)
                .fill(.mint)
                
                // Lerp 5
                Circle(pos: lerp5, size: pointSize/2)
                .fill(.green)
            }
            .animation(data.animation, value: data.t)
            
            // Draggable points
            Group {
                // Point 0
                Circle(pos: data.properties.P0, size: pointSize)
                .fill(.blue)
                .gesture(getGesture(id: 0))

                // Control 0
                Circle(pos: data.properties.C0, size: pointSize)
                .fill(.cyan)
                .gesture(getGesture(id: 1))

                // Point 1
                Circle(pos: data.properties.P1, size: pointSize)
                .fill(.red)
                .gesture(getGesture(id: 2))

                // Control 1
                Circle(pos: data.properties.C1, size: pointSize)
                .fill(.pink)
                .gesture(getGesture(id: 3))
            }
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}