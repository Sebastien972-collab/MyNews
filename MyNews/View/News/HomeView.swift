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
        NavigationStack{
            VStack(alignment: .leading, spacing: 10) {
                ScrollView(.vertical) {
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack {
                            ForEach(searchNews.breakingNews, id: \.self) { new in
                                NavigationLink(destination: NewsDetailView(article: new)) {
                                    HomeImageBubble(article: new)
                                }
                            }
                        }
                    })
                    .padding(.bottom)
                    Divider()
                    Text("Recommendation")
                        .font(.title3)
                        .bold()
                    
                    ForEach(searchNews.news, id: \.self) { article in
                        NavigationLink(destination: NewsDetailView(article: article)) {
                            NewsRow(article: article)
                        }
                    }
                }
                
                Spacer()
            }
            .onAppear(){
                if searchNews.breakingNews.isEmpty || searchNews.news.isEmpty {
                    searchNews.getBreakingNews()
                    searchNews.launchSearch()
                }
            }
            .alert(searchNews.newsError.localizedDescription, isPresented: $searchNews.showError) {
                Button("Ok", role: .cancel) { }
            }
            .navigationTitle(Text("Breaking News"))
            .padding(8)
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
