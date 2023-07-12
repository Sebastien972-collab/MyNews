//
//  ListArticleView.swift
//  MyNews
//
//  Created by Sebby on 12/07/2023.
//

import SwiftUI

struct ListArticleView: View {
    @ObservedObject var newsManger: SearchNewsManager
    var body: some View {
        ScrollView {
            VStack {
                ForEach(newsManger.news, id: \.self) { news in
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
    }
}

struct ListArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ListArticleView(newsManger: SearchNewsManager(service: .shared))
    }
}
