//
//  LinkError.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import Foundation

enum LinkError : Error {
    case invalidField, fieldEmpty, badLink , unapproved, uknowError
}

extension LinkError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidField :
            return NSLocalizedString("Le text n'est pas valide", comment: "Champ invalid")
        case .fieldEmpty :
            return NSLocalizedString("Oups... Ce champ ne peut pas être vide", comment: "Champ vide")
        case .badLink:
            return NSLocalizedString("Oups... il semble que ce lien ne fonctionne pas", comment: "BadLink")
        case .unapproved:
            return NSLocalizedString("Ce lien n'est pas approuvé.", comment: "Unapproved")
        case .uknowError :
            return NSLocalizedString("Une erreur inconnue est survenue", comment: "Unknow Error")
        }
        
    }
    
}
