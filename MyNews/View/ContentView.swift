//
//  ContentView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct ContentView: View {
    enum Selection {
        case home, search, discover, account, bookMark
    }
    @State private var selection = Selection.home
    @StateObject private var favoriteNews = FavoriteNewsManager()
    
    var body: some View {
        TabView(selection: $selection) {
            Text("Flux Rss")
                .onAppear(perform: {
                    FluxService.shared.launchSearch(search: "") { success , items, error in
                        print(items![0].description)
                    }
                })
                .tabItem {
                    Label("Flux", systemImage: "antenna.radiowaves.left.and.right")
                }
                .tag(Selection.discover)
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Selection.home)
            DiscoverView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Selection.search)
        }
        .environmentObject(favoriteNews)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
