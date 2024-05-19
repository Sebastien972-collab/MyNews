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
    @EnvironmentObject private var favoriteNewsVm:  FavoriteNewsManager
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(article.source.name) ° \(article.dateFr)")
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
            HStack {
                Button {
                    safariViewIsPresented.toggle()
                } label: {
                    Text("Lire plus")
                }
                Spacer()
                ShareLink(item: article.url, preview: SharePreview("Icon", image: Image(.myNewsLogo))) {
                    Label("", systemImage: "square.and.arrow.up")
                }

            }
            Spacer()
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
        .sheet(isPresented: $favoriteNewsVm.isSharing, content: {
        })
        
    }
    
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewsDetailView(article: .preview)
                .environmentObject(FavoriteNewsManager())
        }
    }
}
