//
//  LinkManager.swift
//  MyNews
//
//  Created by Sebby on 18/05/2024.
//

import Foundation
import UIKit

class LinkManager: ObservableObject {
    @Published var linkTapped: String = ""
    @Published var linkError: Error = LinkError.uknowError
    @Published var showLinkError: Bool = false
    @Published var fluxLinks: [Link] = FavoriteLinks.shared.all
    let favorLinksManager = FavoriteLinks.shared
    @Published var isEditing: Bool = false
    
    // MARK: - Links Tools
    func refresh() {
        fluxLinks = favorLinksManager.all
    }
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
    
    func removeLink(_ offset: IndexSet) {
        fluxLinks.remove(atOffsets: offset)
        do {
            try favorLinksManager.removeElement(offset)
        } catch  {
            linkError = error
            showLinkError.toggle()
        }
        
    }
    
    func getClipboardContent() {
        guard linkTapped.isEmpty else {
            return
        }
        if let string = UIPasteboard.general.string {
            linkTapped = string
        } else {
            linkTapped = "Le presse-papiers ne contient pas de texte."
        }
    }
}
