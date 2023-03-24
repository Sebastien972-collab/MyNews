//
//  NexsListView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 20/03/2023.
//

import SwiftUI

struct NewsListView: View {
    
    @ObservedObject var searchNews: SearchNews
    var news: [Article]
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(news, id: \.self) { news in
                        NavigationLink {
                            NewsDetailView(article: news)
                        } label: {
                            NewsRow(article: news)
                        }
                    }
                }
                .padding()
                .navigationTitle(Text("Search"))
            }
            Button {
                searchNews.nextPage()
            } label: {
                Text("Charger plus")
                    .padding()
            }
            .alert(searchNews.newsError.localizedDescription, isPresented: $searchNews.showError) {
                Button("Ok", role: .cancel) { }
            }

        }
    }
}

struct NexsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewsListView(searchNews: .shared, news: [.preview, .preview, .preview, .preview, .preview, .preview])
        }
    }
}
