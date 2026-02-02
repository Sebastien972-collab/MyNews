//
//  DiscoverView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 14/03/2023.
//

import SwiftUI

struct DiscoverView: View {
    @State private var allTheme = ["Politique", "Gaming", "Sport", "Education","Santé", "Monde", "Culture","Environnement", "Météo"]
    @StateObject private var searchNews: SearchNewsManager = SearchNewsManager(service: .shared)
    @FocusState private var fieldIsFocused: Bool
    
    // Configuration de la grille pour un look moderne
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fond liquide cohérent
                LinearGradient(colors: [.purple.opacity(0.1), .blue.opacity(0.15), .white],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // --- SEARCH BAR LIQUIDE ---
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            
                            TextField("Rechercher un thème...", text: $searchNews.search)
                                .focused($fieldIsFocused)
                                .submitLabel(.search)
                                .onSubmit { searchNews.launchSearch() }
                            
                            if !searchNews.search.isEmpty {
                                Button { searchNews.search = "" } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(.white.opacity(0.5), lineWidth: 1))
                        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                        .padding(.horizontal)

                        // --- SEGMENTED PICKER GLASS ---
                        Picker("", selection: $searchNews.selection) {
                            ForEach(SearchNewsManager.Selection.allCases, id: \.self) { selection in
                                Text(selection.rawValue).tag(selection)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)

                        // --- THEME CLOUD / RECENT SEARCHES ---
                        VStack(alignment: .leading, spacing: 15) {
                            Text(searchNews.selection == .suggestion ? "Suggestions" : "Recherches récentes")
                                .font(.headline)
                                .padding(.horizontal)

                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(searchNews.selection == .suggestion ? filterTheme : searchNews.recentSearchs, id: \.self) { theme in
                                    themeTile(theme: theme)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Discover")
            .navigationDestination(isPresented: $searchNews.isComplete) {
                NewsListView(searchNews: searchNews)
            }
        }
    }

    // Tuile de thème style "Liquid Glass"
    @ViewBuilder
    func themeTile(theme: String) -> some View {
        Button {
            searchNews.search = theme
            searchNews.launchSearch()
        } label: {
            HStack {
                Text(theme)
                    .fontWeight(.medium)
                Spacer()
                if searchNews.selection == .recent {
                    Button {
                        withAnimation { searchNews.remove(theme) }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.caption2)
                            .padding(4)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                } else {
                    Image(systemName: "arrow.up.right.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                }
            }
            .padding()
            .frame(height: 60)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.4), lineWidth: 1)
            )
            .foregroundColor(.primary)
        }
    }

    private var filterTheme: [String] {
        searchNews.search.isEmpty ? allTheme : allTheme.filter { $0.localizedCaseInsensitiveContains(searchNews.search) }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiscoverView()
        }
    }
}
