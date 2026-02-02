//
//  HomeView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var searchNews = HomeViewManager(service: .shared)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // FOND LIQUIDE : Un dégradé qui donne du relief au verre
                LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.2), .white],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Section Breaking News
                        headerSection(title: "Breaking news")
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(searchNews.breakingNews, id: \.self) { new in
                                    NavigationLink(destination: NewsDetailView(article: new)) {
                                        HomeImageBubble(article: new)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .onAppear(){
                            withAnimation {
                                if searchNews.breakingNews.isEmpty || searchNews.news.isEmpty {
                                    searchNews.launchSearch()
                                }
                            }
                        }
                        
                        // Section Recommendations
                        headerSection(title: "Recommendations")
                        
                        VStack(spacing: 15) {
                            ForEach(searchNews.news, id: \.self) { article in
                                NavigationLink(destination: NewsDetailView(article: article)) {
                                    NewsRow(article: article)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.white.opacity(0.2), lineWidth: 0.5)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .refreshable { searchNews.refresh() }
            }
            .navigationTitle("MyNews")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "line.3.horizontal.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                    }
                }
            }
        }
    }
    
    // Helper pour les titres de section propres
    @ViewBuilder
    func headerSection(title: String) -> some View {
        Text(title)
            .font(.title2)
            .bold()
            .padding(.horizontal)
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
