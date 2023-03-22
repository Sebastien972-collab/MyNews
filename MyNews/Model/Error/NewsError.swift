//
//  NewsError.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation

enum NewsError : Error {
    case invalidField, invalidCharacter, ingredientFieldEmpty, noRecipeFound ,uknowError
}

extension NewsError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidField :
            return NSLocalizedString("Le text n'est pas valide", comment: "Champ invalid")
        case .invalidCharacter :
            return NSLocalizedString("Le charactère n'est pas pris en charge.", comment: "Charactère non pris en charge.")
        case .ingredientFieldEmpty :
            return NSLocalizedString("Oups... Ce champ ne peut pas être vide", comment: "Champ vide")
        case .noRecipeFound :
            return NSLocalizedString("Oups... Nous n'avons pas trouver de recettes.", comment: "Pas de recette trouver")
        case .uknowError :
            return NSLocalizedString("Une erreur inconnue est survenue", comment: "Unknow Error")
        }
        
    }
    
}
