//
//  NewsRow.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct NewsRow: View {
    @Environment(\.colorScheme) var colorScheme
    var article: Article
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: (article.urlToImage!))) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(article.source.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .bold()
                    .padding(.vertical)
                Text(article.dateFr)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.leading)
            Spacer()
                
        }
    }
}

struct NewsRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsRow(article: .preview)
    }
}
