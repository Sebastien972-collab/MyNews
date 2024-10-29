//
//  ApparenceManager.swift
//  MyNews
//
//  Created by Sebby on 15/10/2024.
//

import Foundation
import SwiftUICore

// Enum pour représenter les trois modes
 enum AppAppearance: String, CaseIterable {
    case automatic = "Automatique"
    case light = "Clair"
    case dark = "Sombre"
}

class ApparenceManager: ObservableObject {
   
     @Published var appearance: AppAppearance = .automatic

    // Fonction pour définir le mode en fonction du choix de l'utilisateur
    func colorScheme(for appearance: AppAppearance) -> ColorScheme? {
        switch appearance {
        case .automatic:
            return nil // Suivre le paramètre système
        case .light:
            return .light // Mode clair
        case .dark:
            return .dark // Mode sombre
        }
    }
}
