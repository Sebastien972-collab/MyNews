////
////  LinkStatus.swift
////  MyNews
////
////  Created by Sébastien DAGUIN on 02/02/2026.
////
//
//
//import Foundation
//import SwiftUI
//
//enum LinkStatus: String, Codable, CaseIterable {
//    case checked = "Vérifié"
//    case pending = "En attente"
//    case bad = "Lien erroné"
//    case unapproved = "Non Approuvé"
//    
//    // Pour l'affichage des couleurs en mode Liquid Glass
//    var color: Color {
//        switch self {
//        case .checked: return .green
//        case .pending: return .orange
//        case .bad: return .red
//        case .unapproved: return .secondary
//        }
//    }
//}
//
//struct Link: Identifiable, Hashable, Codable {
//    var id = UUID()
//    var url: String
//    var status: LinkStatus = .pending // On commence par défaut en "En attente"
//    
//    // Pour que ton .contains(Link(link: linkTapped)) fonctionne toujours
//    init(link: String, status: LinkStatus = .pending) {
//        self.url = link
//        self.status = status
//    }
//}
