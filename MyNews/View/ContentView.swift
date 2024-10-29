//
//  ContentView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = TabViewSelection.home
    @StateObject private var favoriteNews = FavoriteNewsManager()
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Now", systemImage: "newspaper")
                }
                .tag(TabViewSelection.home)
            DiscoverView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(TabViewSelection.search)
            FluxView()
                .tabItem {
                    Label("Abonnements", systemImage: "checkmark.rectangle.stack.fill")
                }
                .tag(TabViewSelection.flux)
        }
        .environmentObject(favoriteNews)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
