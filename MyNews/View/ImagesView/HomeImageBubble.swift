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
        ZStack(alignment: .bottom) {
            // L'image de fond
            if let url = article.urlToImage {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
            }
            
            // Le panneau "Glass" superposé
            VStack(alignment: .leading, spacing: 5) {
                Text(article.source.name.uppercased())
                    .font(.caption2)
                    .fontWeight(.heavy)
                    .foregroundColor(.secondary)
                
                Text(article.description)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(2)
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial) // C'est ici que la magie opère
            .cornerRadius(0)
        }
        .frame(width: 320, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

struct HomeImageBubble_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeImageBubble(article: Article.preview)
    }
}
