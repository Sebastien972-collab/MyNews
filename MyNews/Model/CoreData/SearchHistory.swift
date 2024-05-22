//
//  FavoriteSearch.swift
//  MyNews
//
//  Created by Sebby on 20/05/2024.
//

import Foundation
import CoreData

class SearchHistory {
    
    static let shared = SearchHistory(persistenceController: PersistenceController.shared)
    
    let viewContext: NSManagedObjectContext
    
    init(persistenceController: PersistenceController) {
        self.viewContext = persistenceController.container.viewContext
    }
    private var cdSearch: [CDSearch] {
        let request : NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        guard let favoriteCDNews = try? viewContext.fetch(request) else {
            return []
        }
        return favoriteCDNews
    }
    var all: [String] {
        var favoriteSearch: [String] = []
        for search in cdSearch {
            favoriteSearch.append(search.search ?? "Unknow")
        }
        return favoriteSearch
    }
    
    func checkElementIsInHistory(_ search: String) -> Bool {
        all.contains(search)
    }
    ///This function remove a existing recipe
    func removeElementInHistory(search searchToRemove : String) throws {
        for (index ,search) in all.enumerated() {
            if search == searchToRemove {
                viewContext.delete(cdSearch[index])
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
            viewContext.delete(cdSearch[index])
        }
        do {
            try viewContext.save()
        } catch {
            throw error
        }
    }
    private func addNewArticleInHistory(search: String ) throws {
        let searchFav = CDSearch(context: viewContext)
        searchFav.search = search
        
        do {
            try viewContext.save()
        } catch {
            throw error
        }
    }
    /// This function save or unsave a  recipe
    func saveHistory(search: String) throws {
        switch checkElementIsInHistory(search) {
        case true :
            do {
                try removeElementInHistory(search: search)
            } catch {
                throw error
            }
            
        case false :
            do {
                try addNewArticleInHistory(search: search)
            } catch {
                throw error
            }
        }
    }
}
