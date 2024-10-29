//
//  ContentView.swift
//  MyNewsMac
//
//  Created by Sebby on 20/05/2024.
//

import SwiftUI


struct ContentView: View {
    @State private var selection: TabViewSelection = .home
    var body: some View {
        NavigationView(content: {
            ScrollView {
                Form {
                    Section {
                        NavigationLink(destination: HomeView()) { Label("Now", systemImage: "newspaper") }.tag(TabViewSelection.home)
                        NavigationLink(destination: Text("Destination2")) { Label("Search", systemImage: "magnifyingglass") }
                        NavigationLink(destination: FluxView()) { Label("Abonnements", systemImage: "checkmark.rectangle.stack.fill") }
                    } header: {
                        Text("MyNews")
                    }

                }
                .padding(.vertical)
            }
            
        })
        
    }
}

#Preview {
    ContentView()
}
