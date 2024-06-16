//
//  HomeView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var searchNews = HomeViewManager(service: .shared)
    @State private var showView = false
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer()
                    Text("Breaking news")
                        .font(.title3)
                        .bold()
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
                    Text("Recommendations")
                        .font(.title3)
                        .bold()
                    
                    ForEach(searchNews.news, id: \.self) { article in
                        NavigationLink(destination: NewsDetailView(article: article)) {
                            NewsRow(article: article)
                        }
                    }
                }
                .refreshable {
                    searchNews.refresh()
                }
            }
            .onAppear(){
                withAnimation {
                    if searchNews.breakingNews.isEmpty || searchNews.news.isEmpty {
                        searchNews.launchSearch()
                    }
                }
            }
            .alert(searchNews.newsError.localizedDescription, isPresented: $searchNews.showError) {
                Button("Ok", role: .cancel) { }
            }
            .padding(8)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Text("MyNews")
                        .font(.title)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }


            })
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
