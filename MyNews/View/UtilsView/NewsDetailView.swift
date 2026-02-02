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
    @EnvironmentObject private var favoriteNewsVm: FavoriteNewsManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // --- HERO IMAGE ---
                GeometryReader { geo in
                    let minY = geo.frame(in: .global).minY
                    AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: 300 + (minY > 0 ? minY : 0))
                            .clipped()
                            .offset(y: minY > 0 ? -minY : 0) // Effet de parallaxe
                    } placeholder: {
                        Rectangle().fill(.ultraThinMaterial)
                    }
                }
                .frame(height: 300)

                // --- CONTENT CARD (Liquid Glass) ---
                VStack(alignment: .leading, spacing: 20) {
                    // Badge et Date
                    HStack {
                        Text(article.source.name.uppercased())
                            .font(.caption)
                            .fontWeight(.heavy)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text(article.dateFr)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(article.title)
                        .font(.system(.title, design: .rounded))
                        .bold()
                        .foregroundColor(.primary)
                    
                    Divider()
                        .background(Color.primary.opacity(0.1))

                    Text(article.content)
                        .font(.system(.body, design: .rounded))
                        .lineSpacing(6)
                        .foregroundColor(.primary.opacity(0.8))
                    
                    // --- ACTIONS ---
                    HStack(spacing: 20) {
                        Button {
                            safariViewIsPresented.toggle()
                        } label: {
                            Text("Lire l'article complet")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        
                        ShareLink(item: article.url) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(25)
                .background(
                    // On fait remonter la carte sur l'image
                    RoundedRectangle(cornerRadius: 35, style: .continuous)
                        .fill(.background) // S'adapte au mode Sombre/Clair
                        .offset(y: -40)
                )
                .padding(.bottom, -40) // Compense l'offset
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    favoriteNewsVm.saveRecipe(article)
                } label: {
                    Image(systemName: favoriteNewsVm.isFavorite(article) ? "star.fill" : "star")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(favoriteNewsVm.isFavorite(article) ? .yellow : .primary)
                }
            }
        }
        .navigationDestination(isPresented: $safariViewIsPresented) {
            #if !os(macOS)
            SafariView(url: article.url)
            #endif
        }
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
