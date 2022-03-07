//
//  PanelView.swift
//  Bezier-Curve
//
//  Created by Adin Ackerman on 3/5/22.
//

import SwiftUI

struct PanelView: View {
    
//    @Binding var properties: BezierModel
//    @Binding var t: CGFloat
//    @Binding var animation: Animation
    @Binding var data: Data
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    var body: some View {
        List {
            Section(header: Text("Controls")) {
                VStack {
                    HStack {
                        Text("t")
                        Spacer()
                    }
                    Slider(
                        value: $data.t,
                        in: 0...1
                    )
                }
            }
        }
        .navigationTitle("Bezier Curve")
        .frame(minWidth: 300)
        .listStyle(SidebarListStyle())
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.leading")
                })
            }
        }
    }
}

//struct PanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelView()
//    }
//}
