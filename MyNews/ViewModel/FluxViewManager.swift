//
//  FluxViewManager.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import Foundation

class FluxViewManager: ObservableObject {
    // MARK: - Rss Attribut
    @Published var items: [RSSItem] = []
    @Published var inProgress = false
    @Published var error: Error = RSSError.uknowError
    @Published var showError: Bool = false
    @Published var linkManager = LinkManager()
    // MARK: - Rss Attribut
   
    
    // MARK: - Rss Tools
    func fetchRss() {
        self.inProgress.toggle()
        guard !linkManager.fluxLinks.isEmpty else {
            self.inProgress.toggle()
            self.error = RSSError.fieldEmpty
            return showError.toggle()
        }
        // Utilisation de la classe RSSFetcher
        print("Launch RssFetcher ")
        let rssFetcher = RSSFetcher()
        rssFetcher.fetchRSS(links: linkManager.fluxLinks) { linksChecked, rssItems  in
            self.linkManager.fluxLinks = linksChecked
            if let rssItems = rssItems {
                for item in rssItems {
                    self.items.append(item)
                }
            } else {
                self.inProgress.toggle()
                self.error = RSSError.noRssFound
                self.showError.toggle()
            }
        }
        self.inProgress.toggle()
    }
    
    func refresh() {
        items.removeAll()
        fetchRss()
    }
    
    
}
