//
//  FavoriteNews.swift
//  MyNews
//
//  Created by Sebby on 10/07/2023.
//

import Foundation

class FavoriteNewsManager: SearchNewsManager {
     var favoriteNews = FavoriteNews.shared
    
    init() {
        super.init(service: .shared)
         refresh()
    }
    init(service: NewsService, favoriteNews: FavoriteNews) {
        super.init(service: service)
        self.favoriteNews = favoriteNews
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
    func isFavorite(_ article: Article) -> Bool {
        return !news.filter {
            $0.id == article.id
        }.isEmpty
    }
    
    override func refresh() {
        news = favoriteNews.all
        super.refresh()
    }
    
    
}
