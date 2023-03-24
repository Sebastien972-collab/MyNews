//
//  DiscoverView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 14/03/2023.
//

import SwiftUI

struct DiscoverView: View {
    @State private var allTheme = ["Politic", "Gaming", "Sport", "Education","Santé", "Monde", "Culture","Environnement", "Météo"]
    @State private var searchViewIsPresented = false
    @ObservedObject var searchNews: SearchNews
    @AppStorage("recentSearch") private var recentSearch = "Environnement"
    @FocusState private var fieldIsFocused : Bool
    
    var body: some View {
        NavigationStack {
            ScrollView(content: {
                VStack {
                    TextField("", text: $searchNews.search, prompt: Text("Theme to search"))
                        .onSubmit {
                            searchNews.launchSearch(nil)
                            searchNews.search.removeAll()
                            recentSearch = searchNews.search
                        }
                        .submitLabel(.search)
                        .focused($fieldIsFocused)
                        .padding()
                    
                    ForEach(filterTheme, id: \.self) { theme in
                        Button(action: {
                            searchNews.launchSearch(theme)
                        }, label: {
                            Text(theme)
                        })
                        .navigationDestination(isPresented: $searchNews.isComplete) {
                            NewsListView(searchNews: searchNews, news: searchNews.news)
                        }
                    }
                }
            })
            .onTapGesture {
                fieldIsFocused = false
            }
            .alert(searchNews.newsError.localizedDescription, isPresented: $searchNews.showError) {
                Button("Ok", role: .cancel) { }
            }
            .onAppear() {
                searchNews.page = 1
            }
            .navigationTitle(Text("Discover"))
            
        }
    }
    private var filterTheme: [String] {
        if searchNews.search.isEmpty {
            return allTheme
        } else {
            return allTheme.filter { $0.localizedCaseInsensitiveContains(searchNews.search) }
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiscoverView(searchNews: .shared)
        }
    }
}
