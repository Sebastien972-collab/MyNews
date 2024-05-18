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
    private var cdLinks: [CDRssLink] {
        let request : NSFetchRequest<CDRssLink> = CDRssLink.fetchRequest()
        guard let favoriteCDNews = try? viewContext.fetch(request) else {
            return []
        }
        return favoriteCDNews
    }
    var all : [Link] {
        var favoriteLinks: [Link] = []
        for link in cdLinks {
            let newLink = Link(link: link.links ?? "")
            favoriteLinks.append(newLink)
        }
        return favoriteLinks
    }
    
    func checkElementIsFavorite(link newLinks: Link) -> Bool {
        for link in all {
            if  newLinks == link {
                return true
            }
        }
        return false
    }
    ///This function remove a existing recipe
    func removeElementInFavorite(link linkToRemove : Link) throws {
        for (index ,link) in all.enumerated() {
            if link == linkToRemove {
                viewContext.delete(cdLinks[index])
            }
        }
        do {
            try viewContext.save()
        } catch {
            throw error
        }
    }
    func removeElement(_ indexSet: IndexSet) throws {
        for index in indexSet.reversed() {
            viewContext.delete(cdLinks[index])
        }
        do {
            try viewContext.save()
        } catch {
            throw error
        }
    }
    private func addNewArticleFavorite(link : Link) throws {
        let linkFav = CDRssLink(context: viewContext)
        linkFav.links = link.link
        
        do {
            try viewContext.save()
        } catch {
            throw error
        }
    }
    /// This function save or unsave a  recipe
    func saveArticle(link: Link) throws {
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
