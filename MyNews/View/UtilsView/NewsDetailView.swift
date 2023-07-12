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
    @StateObject var favoriteNewsVm = FavoriteNewsManager()
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
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    favoriteNewsVm.saveRecipe(article)
                } label: {
                    Image(systemName: "star.fill")
                        .foregroundColor(favoriteNewsVm.isFavorite(article) ? .yellow : .gray)
                }

            }
        })
        .fullScreenCover(isPresented: $safariViewIsPresented) {
            SafariView(url: article.url)
        }
    }
    
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewsDetailView(article: .preview, favoriteNewsVm: FavoriteNewsManager())
        }
    }
}
