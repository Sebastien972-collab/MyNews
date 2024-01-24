//
//  ContentView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct ContentView: View {
    enum Selection {
        case home, dicover, account, bookMark
    }
    @State private var selection = Selection.dicover
    @StateObject private var searchNews = SearchNewsManager(service: .shared)
    @StateObject var favoriteNews = FavoriteNewsManager()
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Selection.home)
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "network")
                }
                .tag(Selection.dicover)
            BookMarkView()
                .tabItem {
                    Label("Bookmark", systemImage: "bookmark")
                }
                .tag(Selection.bookMark)
        }
        .environmentObject(favoriteNews)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
