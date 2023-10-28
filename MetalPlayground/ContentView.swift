//
//  ContentView.swift
//  MetalPlayground
//
//  Created by i on 10/21/23.
//

import SwiftData
import SwiftUI

struct RendererItem: Identifiable {
    let id: String
    let rendererType: BaseRenderer.Type
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    private let items: [RendererItem] = [
        RendererItem(id: "Hello Triangle", rendererType: HTRenderer.self)
    ]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        MetalView(rendererType: item.rendererType)
                    } label: {
                        Text(item.id)
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
