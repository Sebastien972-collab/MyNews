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
        request.sortDescriptors = [NSSortDescriptor(key: "links", ascending: true)]
        guard let favoriteCDNews = try? viewContext.fetch(request) else {
            return []
        }
        return favoriteCDNews
    }
    var all : [Link] {
        var favoriteLinks: [Link] = []
        for link in cdLinks {
            var status: Link.StatusLink {
                for status in Link.StatusLink.allCases {
                    if link.status ?? ""  == status.rawValue {
                        return status
                    }
                }
                return .pending
            }
            let newLink = Link(link: link.links ?? "", status: status)
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
        for stored in cdLinks where stored.links == linkToRemove.link {
            viewContext.delete(stored)
        }
        do {
            try viewContext.save()
        } catch {
            throw error
        }
    }
    func removeElement(_ indexSet: IndexSet) throws {
        let snapshot = cdLinks
        for index in indexSet where snapshot.indices.contains(index) {
            viewContext.delete(snapshot[index])
        }
        try viewContext.save()
    }

    func updateStatuses(_ links: [Link]) throws {
        for stored in cdLinks {
            if let link = links.first(where: { $0.link == stored.links }) {
                stored.status = link.status.rawValue
            }
        }
        try viewContext.save()
    }

    private func addNewArticleFavorite(link : Link) throws {
        let linkFav = CDRssLink(context: viewContext)
        linkFav.links = link.link
        linkFav.status = link.status.rawValue
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
