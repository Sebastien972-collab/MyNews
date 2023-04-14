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
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                        .frame(width: 80, height: 80)
                }
            } else {
                Image(systemName: "network")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
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
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black))
        .shadow(radius: 25)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        
    }
}

struct HomeImageBubble_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeImageBubble(article: Article.preview)
    }
}
