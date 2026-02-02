//
//  BookMarkView.swift
//  MyNews
//
//  Created by Sebby on 10/07/2023.
//

import SwiftUI

struct BookMarkView: View {
    @EnvironmentObject var favoriteNewsVm: FavoriteNewsManager
    
    var body: some View {
        ZStack {
            // Fond dégradé liquide (Aqua/Teal pour différencier des autres vues)
            LinearGradient(colors: [.teal.opacity(0.1), .blue.opacity(0.1), .white],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            if favoriteNewsVm.news.isEmpty {
                // --- EMPTY STATE DESIGN ---
                VStack(spacing: 20) {
                    Image(systemName: "bookmark.slash")
                        .font(.system(size: 80))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white.opacity(0.5), lineWidth: 1))
                    
                    Text("Aucun favori pour le moment")
                        .font(.headline)
                    
                    Text("Enregistrez les articles qui vous plaisent pour les retrouver ici plus tard.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .transition(.scale.combined(with: .opacity))
            } else {
                // --- LISTE DES FAVORIS ---
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ListArticleView(newsManger: favoriteNewsVm, title: "Mes Favoris")
                            .padding(.top)
                    }
                }
            }
        }
        .navigationTitle("Favoris")
        .alert(favoriteNewsVm.newsError.localizedDescription, isPresented: $favoriteNewsVm.showError) {
            Button("Ok", role: .cancel) { }
        }
    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookMarkView()
    }
}
