//
//  NewsError.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation

enum NewsError : Error {
    case invalidField, invalidCharacter, fieldEmpty, noNewsFound ,uknowError
}

extension NewsError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidField :
            return NSLocalizedString("Le text n'est pas valide", comment: "Champ invalid")
        case .invalidCharacter :
            return NSLocalizedString("Le charactère n'est pas pris en charge.", comment: "Charactère non pris en charge.")
        case .fieldEmpty :
            return NSLocalizedString("Oups... Ce champ ne peut pas être vide", comment: "Champ vide")
        case .noNewsFound :
            return NSLocalizedString("Oups... Nous n'avons rien trouver pour cette recherche.", comment: "Pas de news trouver")
        case .uknowError :
            return NSLocalizedString("Une erreur inconnue est survenue", comment: "Unknow Error")
        }
        
    }
    
}
