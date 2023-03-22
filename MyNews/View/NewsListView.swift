//
//  NexsListView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 20/03/2023.
//

import SwiftUI

struct NewsListView: View {
    var news: [Article]
    var body: some View {
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
    }
}

struct NexsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewsListView(news: [.preview, .preview, .preview, .preview, .preview, .preview])
        }
    }
}
