//
//  NexsListView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 20/03/2023.
//

import SwiftUI

struct NewsListView: View {
    @ObservedObject var searchNews: SearchNewsManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Fond pour maintenir l'effet de transparence
            LinearGradient(colors: [.blue.opacity(0.1), .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Ta vue de liste existante (assure-toi qu'elle utilise les NewsRow en verre)
                ListArticleView(newsManger: searchNews, title: "Résultats")
            }
            
            // --- CHARGEMENT / PAGINATION LIQUIDE ---
            ZStack {
                if searchNews.inProgress {
                    HStack(spacing: 12) {
                        ProgressView()
                            .tint(.blue)
                        Text("Recherche en cours...")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.5), lineWidth: 1))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    Button {
                        withAnimation(.spring()) {
                            searchNews.nextPage()
                        }
                    } label: {
                        HStack {
                            Text("Voir plus d'articles")
                                .fontWeight(.bold)
                            Image(systemName: "arrow.down.circle.fill")
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 25)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
                    }
                    .padding(.bottom, 20)
                }
            }
            .animation(.spring(), value: searchNews.inProgress)
        }
        .navigationTitle(searchNews.search.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .alert(searchNews.newsError.localizedDescription, isPresented: $searchNews.showError) {
            Button("Ok", role: .cancel) { }
        }
    }
}

struct NexsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewsListView(searchNews: .preview)
        }
    }
}
