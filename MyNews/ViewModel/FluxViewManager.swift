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
    @Published var linkError: Error = LinkError.uknowError
    @Published var showError: Bool = false
    @Published var fluxLinks: [Link] = [
                                        Link(link: "https://www.numerama.com/feed/"),
                                        Link(link: "https://www.frandroid.com/feed"),
                                        Link(link: "https://www.mac4ever.com/flux/rss/category/")
    ]
    @Published var linkTapped: String = ""
    
    
    func addLink() {
        guard URL(string: linkTapped) != nil else {
            linkTapped.removeAll()
            linkError = LinkError.invalidField
            return showError.toggle()
        }
        let newLink = Link(link: linkTapped)
        fluxLinks.append(newLink)
        linkTapped.removeAll()
        
    }
    
    func removeLink(_ offset: IndexSet) {
        fluxLinks.remove(atOffsets: offset)
    }
    func fetchRss() {
        guard !fluxLinks.isEmpty else {
            self.linkError = LinkError.fieldEmpty
            return showError.toggle()
        }
        // Utilisation de la classe RSSFetcher
        print("Launch RssFetcher ")
        let rssFetcher = RSSFetcher()
        rssFetcher.fetchRSS(links: fluxLinks) { linksChecked, rssItems  in
            self.fluxLinks = linksChecked
            if let rssItems = rssItems {
                for item in rssItems {
                    self.items.append(item)
                }
            } else {
                self.rssError = RSSError.noRssFound
                self.showError.toggle()
            }
        }
    }
}
