//
//  FluxViewManager.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import Foundation

class FluxViewManager: ObservableObject {
    enum SegmentedCommand: String,Identifiable, CaseIterable, Hashable {
        case me, explore
        var id: Self { self }
    }
    @Published var segmentedControl: SegmentedCommand = .me
    @Published var items: [RSSItem] = []
    @Published var listBeingModified = false
    @Published var rssError: Error = RSSError.uknowError
    @Published var showError: Bool = false
    
    
    
    
    func fetchRss() {
        // Utilisation de la classe RSSFetcher
        print("Launch RssFetcher ")
        let rssFetcher = RSSFetcher()
        rssFetcher.fetchRSS(url: "") { rssItems in
            if let rssItems = rssItems {
                for item in rssItems {
                    self.items.append(item)
//                        print("Titre : \(item.title)")
//                        print("Lien : \(item.link)")
//                        print("Description : \(item.description)\n")
                }
            } else {
                print("Impossible de récupérer les flux RSS.")
            }
        }
    }
}
