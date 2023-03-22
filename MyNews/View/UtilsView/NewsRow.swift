//
//  NewsRow.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct NewsRow: View {
    var article: Article
    
    var body: some View {
        HStack {
            if let url = article.urlToImage {
                AsyncImage(url: URL(string: (url))) { image in
                    image
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "network")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .foregroundColor(.red)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(article.source.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(article.title)
                    .font(.headline)
                    .bold()
                    .padding(.vertical)
                Text(article.publishedAt)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
                
        }
    }
}

struct NewsRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsRow(article: .preview)
    }
}
