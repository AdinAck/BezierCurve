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
    @State var t: CGFloat = 0
    @State var resolution: CGFloat = 128
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    private func updateData(t: CGFloat, resolution: Int) {
        data.resolution = resolution
        data.t = (t*CGFloat(data.resolution)).rounded()/CGFloat(data.resolution)
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
                        value: $t,
                        in: 0...1
                    )
                        .onChange(of: t) { t in
                            updateData(t: t, resolution: data.resolution)
                        }
                }
                VStack {
                    HStack {
                        Text("Resolution")
                        Spacer()
                    }
                    Slider(
                        value: $resolution,
                        in: 2...128
                    )
                        .onChange(of: resolution) { resolution in
                            updateData(t: t, resolution: Int(resolution.rounded()))
                        }
                }
                Toggle("Place points", isOn: $data.placingPoints)
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
