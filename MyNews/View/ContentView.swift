//
//  ContentView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct ContentView: View {
    enum Selection {
        case home, flux,  search, discover, account, bookMark
    }
    @State private var selection = Selection.home
    @StateObject private var favoriteNews = FavoriteNewsManager()
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Now", systemImage: "newspaper")
                }
                .tag(Selection.home)
            DiscoverView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Selection.search)
            FluxView()
                .tabItem {
                    Label("Abonnements", systemImage: "checkmark.rectangle.stack.fill")
                }
                .tag(Selection.flux)
        }
        .environmentObject(favoriteNews)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
