//
//  FavoriteNews.swift
//  MyNews
//
//  Created by Sebby on 10/07/2023.
//

import Foundation

class FavoriteNewsManager: SearchNewsManager {
    @Published var favoriteNews = FavoriteNews.shared
    
    init() {
        super.init(service: .shared)
         refresh()
    }
    
    func saveRecipe(_ article: Article) {
        do {
            try favoriteNews.saveArticle(article: article)
            refresh()
        } catch  {
            newsError = error
            showError.toggle()
        }
    }
    func removeAll() {
        do {
            try favoriteNews.removeAll()
            refresh()
        } catch  {
            newsError = error
            showError.toggle()
        }
    }
    func isFavorite(_ article: Article) -> Bool {
        news.contains(article)
    }
    
    func refresh() {
        news = favoriteNews.all
    }
    
    
}
