//
//  NewsDetailView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 14/03/2023.
//

import SwiftUI

struct NewsDetailView: View {
    let article: Article
    @State private var safariViewIsPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(article.source.name) ° \(article.publishedAt)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(article.title)
                .font(.title)
                .bold()
            AsyncImage(url: URL(string: article.urlToImage ?? Article.preview.urlToImage!)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
            } placeholder: {
                ProgressView()
            }
            Text(article.content)
            Spacer()
            Button {
                safariViewIsPresented.toggle()
            } label: {
                Text("Lire plus")
            }
        }
        .padding()
        .fullScreenCover(isPresented: $safariViewIsPresented) {
            SafariView(url: article.url)
        }
    }
    
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(article: .preview)
    }
}
