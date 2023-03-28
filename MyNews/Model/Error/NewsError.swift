//
//  NewsError.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation

enum NewsError : Error {
    case invalidField, pageLimit, fieldEmpty, noNewsFound ,uknowError
}

extension NewsError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidField :
            return NSLocalizedString("Le text n'est pas valide", comment: "Champ invalid")
        case .pageLimit :
            return NSLocalizedString("Sorry you have reached the limit of page to consult", comment: "Page Milit")
        case .fieldEmpty :
            return NSLocalizedString("Oups... Ce champ ne peut pas être vide", comment: "Champ vide")
        case .noNewsFound :
            return NSLocalizedString("Oups... Nous n'avons rien trouver pour cette recherche.", comment: "Pas de news trouver")
        case .uknowError :
            return NSLocalizedString("Une erreur inconnue est survenue", comment: "Unknow Error")
        }
        
    }
    
}
