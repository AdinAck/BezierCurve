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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
