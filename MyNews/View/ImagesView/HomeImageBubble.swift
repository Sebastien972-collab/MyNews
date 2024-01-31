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
        VStack(spacing: 5) {
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
            
            VStack(alignment: .leading, spacing: 5) {
                Text(article.source.name)
                Text(article.description)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .foregroundColor(.black)
                    .bold()
            }
            .padding(5)
            
            
        }
        .frame(width: 350, height: 350)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .clipped()
        
    }
}

struct HomeImageBubble_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeImageBubble(article: Article.preview)
    }
}
