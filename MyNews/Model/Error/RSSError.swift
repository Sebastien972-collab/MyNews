//
//  RSSError.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import Foundation

enum RSSError : Error {
    case invalidField, fieldEmpty, noRssFound, unavailableSources, uknowError
}

extension RSSError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidField :
            return NSLocalizedString("Le text n'est pas valide", comment: "Champ invalid")
        case .fieldEmpty :
            return NSLocalizedString("Oups... Ce champ ne peut pas être vide", comment: "Champ vide")
        case .noRssFound :
            return NSLocalizedString("Oups... Nous n'avons rien trouver pour cette recherche.", comment: "Pas de news trouver")
        case .unavailableSources:
            return NSLocalizedString("Certaines sources sont indisponibles. Les articles déjà enregistrés sont conservés.", comment: "Erreur de mise à jour RSS")
        case .uknowError :
            return NSLocalizedString("Une erreur inconnue est survenue", comment: "Unknow Error")
        }
        
    }
    
}
