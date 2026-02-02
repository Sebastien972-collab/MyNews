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
        HStack(alignment: .center, spacing: 16) {
            // L'image avec un coin arrondi plus prononcé (Liquid Style)
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.ultraThinMaterial)
                    ProgressView()
                }
                .frame(width: 90, height: 90)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                // Badge Source
                Text(article.source.name)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
                
                // Titre
                Text(article.title)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Date
                Text(article.dateFr)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Un petit indicateur discret
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(12)
        // L'effet Liquid Glass appliqué au container
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.4), lineWidth: 1.5)
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct NewsRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsRow(article: .preview)
    }
}
