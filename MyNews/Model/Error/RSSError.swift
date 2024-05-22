//
//  RSSError.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import Foundation

enum RSSError : Error {
    case invalidField, fieldEmpty, noRssFound ,uknowError
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
        case .uknowError :
            return NSLocalizedString("Une erreur inconnue est survenue", comment: "Unknow Error")
        }
        
    }
    
}
