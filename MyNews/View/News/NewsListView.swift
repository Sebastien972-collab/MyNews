//
//  NexsListView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 20/03/2023.
//

import SwiftUI

struct NewsListView: View {
    @ObservedObject var searchNews: SearchNewsManager
    var body: some View {
        VStack {
            ListArticleView(newsManger: searchNews, title: "Search")
            ZStack(content: {
                if searchNews.inProgress {
                    VStack {
                        ProgressView {
                            Text("Chargement en cours ")
                        }
                    }
                } else {
                    Button {
                        withAnimation {
                            searchNews.nextPage()
                        }
                    } label: {
                        Text("Charger plus")
                            .padding()
                    }
                }
               
            })
            .alert(searchNews.newsError.localizedDescription, isPresented: $searchNews.showError) {
                Button("Ok", role: .cancel) { }
            }
            
        }
    }
}

struct NexsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewsListView(searchNews: .preview)
        }
    }
}
