//
//  FavoriteNews.swift
//  MyNews
//
//  Created by Sebby on 10/07/2023.
//

import Foundation

import CoreData

class FavoriteNews {

    static let shared = FavoriteNews(persistenceController: PersistenceController.shared)

    let viewContext: NSManagedObjectContext

    init(persistenceController: PersistenceController) {
        self.viewContext = persistenceController.container.viewContext
    }
    private var cdArticles : [CDArticles] {
        let request : NSFetchRequest<CDArticles> = CDArticles.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "title" , ascending: true),
            NSSortDescriptor(key: "author", ascending: true)
        ]
        guard let favoriteCDNews = try? viewContext.fetch(request) else {
            return []
        }
        return favoriteCDNews
    }
    var all : [Article] {
        var favoriteNews : [Article] = []
        for article in cdArticles {
            let newArticle = Article(source: Source(name: article.sourceName ?? ""), author: article.author ?? "", title: article.title ?? "", description: article.description, url: article.url ?? "", urlToImage: article.urlToImage ?? "", publishedAt: article.publishedAt ?? "", content: article.content ?? "")
            favoriteNews.append(newArticle)
        }
        return favoriteNews
    }

    func checkElementIsFavorite(article newArticle: Article) -> Bool {
        for article in all {
            if  newArticle.id == article.id {
                return true
            }
        }
       return false
    }
    ///This function remove a existing recipe
     func removeElementInFavorite(article articleToRemove : Article) throws {
        for (index ,article) in all.enumerated() {
            if article.id == articleToRemove.id {
                viewContext.delete(cdArticles[index])
                
                do {
                    try viewContext.save()
                }
                catch {
                    throw error
                }
            }
        }
    }
    private func addNewArticleFavorite(article : Article) throws {
        let articleFav = CDArticles(context: viewContext)
        articleFav.title = article.title
        articleFav.articleDescription = article.description
        articleFav.author = article.author
        articleFav.content = article.content
        articleFav.publishedAt = article.publishedAt
        articleFav.sourceName = article.source.name
        articleFav.url = article.url
        articleFav.urlToImage = article.urlToImage

        do {
            try viewContext.save()
        } catch {
            throw error
        }
    }
    /// This function save or unsave a  recipe
    func saveArticle(article: Article) throws {
        switch checkElementIsFavorite(article: article) {
        case true :
            do {
                try removeElementInFavorite(article: article)
                print("\(article.title) is removed with success ")

            } catch {
                throw error
            }

        case false :
            do {
                try addNewArticleFavorite(article: article)
                print("\(article.title) is added with success ")
            } catch {
                throw error
            }
        }
    }
}
