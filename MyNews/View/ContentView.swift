//
//  ContentView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct ContentView: View {
    enum Selection {
        case home, dicover
    }
    @State private var selection = Selection.home
    @StateObject private var searchNews = SearchNews.shared
    var body: some View {
        TabView(selection: $selection) {
            HomeView(searchNews: searchNews)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Selection.home)
            DiscoverView(searchNews: searchNews)
                .tabItem {
                    Label("Discover", systemImage: "network")
                }
                .tag(Selection.dicover)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
