//
//  HomeView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var searchNews = HomeVM(service: .shared)
    @EnvironmentObject var favoriteNewsManager:  FavoriteNewsManager
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                ScrollView(.vertical) {
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack {
                            ForEach(searchNews.breakingNews, id: \.self) { new in
                                NavigationLink(destination: NewsDetailView(article: new, favoriteNewsVm: favoriteNewsManager)) {
                                    HomeImageBubble(article: new)
                                }
                            }
                        }
                    })
                    .padding(.bottom)
                    
                    Text("Recommendation")
                        .font(.title3)
                        .bold()
                    
                    ForEach(searchNews.news, id: \.self) { article in
                        NavigationLink(destination: NewsDetailView(article: article, favoriteNewsVm: favoriteNewsManager)) {
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
