//
//  FavoriteLinks.swift
//  MyNews
//
//  Created by Sebby on 10/05/2024.
//

import Foundation
import CoreData

class FavoriteLinks {
    
    static let shared = FavoriteLinks(persistenceController: PersistenceController.shared)
    
    let viewContext: NSManagedObjectContext
    
    init(persistenceController: PersistenceController) {
        self.viewContext = persistenceController.container.viewContext
    }
    private var cdLinks : [CDRssLink] {
        let request : NSFetchRequest<CDRssLink> = CDRssLink.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "title" , ascending: true),
            NSSortDescriptor(key: "author", ascending: true)
        ]
        guard let favoriteCDNews = try? viewContext.fetch(request) else {
            return []
        }
        return favoriteCDNews
    }
    var all : [String] {
        var favoriteLinks: [String] = []
        for link in cdLinks {
            let newLink = link.links ?? ""
            favoriteLinks.append(newLink)
        }
        return favoriteLinks
    }
    
    func checkElementIsFavorite(link newLinks: String) -> Bool {
        for link in all {
            if  newLinks == link {
                return true
            }
        }
        return false
    }
    ///This function remove a existing recipe
    func removeElementInFavorite(link linkToRemove : String) throws {
        for (index ,link) in all.enumerated() {
            if link == linkToRemove {
                viewContext.delete(cdLinks[index])
            }
        }
    }
    private func addNewArticleFavorite(link : String) throws {
        let linkFav = CDRssLink(context: viewContext)
        linkFav.links = link
        
        do {
            try viewContext.save()
        } catch {
            throw error
        }
    }
    /// This function save or unsave a  recipe
    func saveArticle(link: String) throws {
        switch checkElementIsFavorite(link: link) {
        case true :
            do {
                try removeElementInFavorite(link: link)
                print("\(link) is removed with success ")
                
            } catch {
                throw error
            }
            
        case false :
            do {
                try addNewArticleFavorite(link: link)
                print("\(link) is added with success ")
            } catch {
                throw error
            }
        }
    }
}
