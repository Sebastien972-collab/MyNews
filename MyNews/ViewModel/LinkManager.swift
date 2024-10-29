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
    @Published var fluxLinks: [Link] = FavoriteLinks.shared.all
    let favorLinksManager = FavoriteLinks.shared
    @Published var isEditing: Bool = false
    
    // MARK: - Links Tools
    ///Refresh LinkManager
    func refresh() {
        fluxLinks = favorLinksManager.all
    }
    ///Ajoute un lien dans fluxlinks
    func addLink() {
        guard !linkTapped.isEmpty else {
            return
        }
        guard !fluxLinks.contains(Link(link: linkTapped)) else {
            linkError = LinkError.invalidField
            linkTapped.removeAll()
            return showLinkError.toggle()
        }
        guard URL(string: linkTapped) != nil else {
            linkTapped.removeAll()
            linkError = LinkError.invalidField
            return showLinkError.toggle()
        }
        
        do {
            let newLink = Link(link: linkTapped)
            try favorLinksManager.saveArticle(link: newLink)
            fluxLinks.append(newLink)
        } catch  {
            linkError = error
            showLinkError.toggle()
        }
        
        linkTapped.removeAll()
        
    }
    ///Supprime un lie
    func removeLink(_ offset: IndexSet) {
        fluxLinks.remove(atOffsets: offset)
        do {
            try favorLinksManager.removeElement(offset)
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
