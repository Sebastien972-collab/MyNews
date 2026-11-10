//
//  LinkManager.swift
//  MyNews
//
//  Created by Sebby on 18/05/2024.
//

import Foundation

class LinkManager: ObservableObject {
    @Published var linkTapped: String = ""
    @Published var linkError: Error = LinkError.uknowError
    @Published var showLinkError: Bool = false
    @Published var fluxLinks: [Link]
    let favorLinksManager: FavoriteLinks
    @Published var isEditing: Bool = false
    
    init(favorLinksManager: FavoriteLinks = .shared) {
        self.favorLinksManager = favorLinksManager
        self.fluxLinks = favorLinksManager.all
    }

    // MARK: - Links Tools
    ///Refresh LinkManager
    func refresh() {
        fluxLinks = favorLinksManager.all
    }
    ///Ajoute un lien dans fluxlinks
    func addLink() {
        linkTapped = linkTapped.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !linkTapped.isEmpty else {
            return
        }
        guard !fluxLinks.contains(Link(link: linkTapped)) else {
            linkError = LinkError.invalidField
            linkTapped.removeAll()
            return showLinkError.toggle()
        }
        guard let url = URL(string: linkTapped), url.host != nil,
              ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            linkTapped.removeAll()
            linkError = LinkError.invalidField
            return showLinkError.toggle()
        }
        
        do {
            let newLink = Link(link: linkTapped)
            try favorLinksManager.saveArticle(link: newLink)
            refresh()
        } catch  {
            linkError = error
            showLinkError.toggle()
        }
        
        linkTapped.removeAll()
        
    }
    ///Supprime un lie
    func removeLink(_ offset: IndexSet) {
        do {
            let linksToRemove = offset.compactMap { fluxLinks.indices.contains($0) ? fluxLinks[$0] : nil }
            for link in linksToRemove {
                try favorLinksManager.removeElementInFavorite(link: link)
            }
            refresh()
        } catch  {
            linkError = error
            showLinkError.toggle()
        }
    }
    
    ///Une fonction qui récupère lun lien dans le presse papier.
    func getClipboardContent() {
//        guard linkTapped.isEmpty else {
//            return
//        }
//        if let string = UIPasteboard.general.url {
//            linkTapped = "\(string)"
//        } else {
//            print("Le presse-papiers ne contient pas de texte.")
//        }
    }
}
