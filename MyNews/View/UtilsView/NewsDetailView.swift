//
//  NewsDetailView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 14/03/2023.
//

import SwiftUI

struct NewsDetailView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(article.source.name) ° \(article.publishedAt)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(article.title)
                .font(.title)
                .bold()
            AsyncImage(url: URL(string: article.urlToImage ?? Article.preview.urlToImage!)) { image in
                image.resizable()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
            } placeholder: {
                ProgressView()
            }
            Text(article.content)
            Spacer()
            Button(action: {
                
            }, label: {
                Text("Lire plus")
            })
        }
        
        
        .padding()
    }
    
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(article: .preview)
    }
}
