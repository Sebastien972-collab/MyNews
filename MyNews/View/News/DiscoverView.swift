//
//  DiscoverView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 14/03/2023.
//

import SwiftUI

struct DiscoverView: View {
    @State private var allTheme = ["Politique", "Gaming", "Sport", "Education","Santé", "Monde", "Culture","Environnement", "Météo"]
    @State private var searchViewIsPresented = false
    @StateObject private var searchNews: SearchNewsManager = SearchNewsManager(service: .shared)
    @FocusState private var fieldIsFocused: Bool
    @State private var okButtonOpacity: Double = 0
    
    var body: some View {
        NavigationStack {
            ScrollView(content: {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .padding()
                        TextField("", text: $searchNews.search, prompt: Text("Theme to search"))
                            .padding(10)
                            .onSubmit {
                                searchNews.launchSearch()
                            }
                            .submitLabel(.search)
                            .focused($fieldIsFocused)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray))
                    .shadow(color: .gray, radius: 10)
                    .padding()
                    
                    Picker("", selection: $searchNews.selection) {
                        ForEach(SearchNewsManager.Selection.allCases, id: \.self) { selection in
                            Text(selection.rawValue)
                                .tag(selection)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.bottom)
                    ForEach(searchNews.selection == .suggestion ? filterTheme : searchNews.recentSearchs, id: \.self) { theme in
                        Button(action: {
                            searchNews.search = theme
                            searchNews.launchSearch()
                        }, label: {
                            HStack {
                                Text(theme)
                                    .foregroundStyle(searchNews.selection == .suggestion ? .blue : .secondary)
                                    .italic(searchNews.selection == .suggestion ? false : true)
                                if searchNews.selection == .recent {
                                    Button {
                                        withAnimation {
                                            searchNews.remove(theme)
                                        }
                                    } label: {
                                        Text("X")
                                    }
                                }
                            }
                        })
                    }
                    
                }
            })
            .alert(searchNews.newsError.localizedDescription, isPresented: $searchNews.showError) {
                Button("Ok", role: .cancel) { }
            }
            .onAppear() {
                searchNews.resetPage()
            }
            .navigationDestination(isPresented: $searchNews.isComplete) {
                NewsListView(searchNews: searchNews)
            }
            .navigationTitle(Text("Discover"))
            .toolbar(content: {
                if fieldIsFocused {
#if !os(macOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            fieldIsFocused.toggle()
                        } label: {
                            Text("OK")
                        }
                        .opacity(okButtonOpacity)
                        .onAppear(perform: {
                            withAnimation(.easeIn(duration: 0.5)) {
                                okButtonOpacity = 1
                            }
                        })
                    }
#endif
                    
                }
            })
            
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
            DiscoverView()
        }
    }
}
