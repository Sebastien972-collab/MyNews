//
//  HomeView.swift
//  MyNewsMac
//
//  Created by Sebby on 16/06/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var searchNews = HomeViewManager(service: .shared)
    @State private var showView = false
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                Text("Breaking News")
                    .font(.title)
                ForEach(searchNews.breakingNews, id: \.self) { new in
                    NavigationLink {
                        NewsDetailView(article: new)
                    } label: {
                        HomeImageBubble(article: new)
                    }

                }
                
            }
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .alert(searchNews.newsError.localizedDescription, isPresented: $searchNews.showError, actions: {
            Button(role: .cancel, action: {}) {
                Text("OK")
            }
        })
        .onAppear() {
            searchNews.launchSearch()
        }
    }
    
}

#Preview {
    HomeView()
}
