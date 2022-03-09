//
//  ContentView.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var data: Data = Data()
    
    var body: some View {
        HStack {
            NavigationView {
                PanelView(data: $data)
                MainView(data: $data)
                .background(.background)
                .gesture(DragGesture(minimumDistance: 0).onEnded { gesture in
                    if data.placingPoints {
                        data.points.append(gesture.location)
                    }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
