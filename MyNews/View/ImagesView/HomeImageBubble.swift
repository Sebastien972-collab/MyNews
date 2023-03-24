//
//  HomeImageBubble.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct HomeImageBubble: View {
    var article: Article
    
    var body: some View {
        ZStack {
            if let url = article.urlToImage {
                AsyncImage(url: URL(string: (url))) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "network")
                    .resizable()
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Spacer()
                    Text(article.source.name)
                    Text(article.description)
                        .lineLimit(2)
                }
                .foregroundColor(.white)
                Spacer()
            }
            .padding()
        }
        .frame(width: 350, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay(RoundedRectangle(cornerRadius: 25).stroke())
        .shadow(radius: 5)
    }
}

struct HomeImageBubble_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeImageBubble(article: Article.preview)
    }
}