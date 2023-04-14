//
//  SearchError.swift
//  MyNewsTests
//
//  Created by Sébastien DAGUIN on 13/04/2023.
//

import XCTest
@testable import MyNews

final class NewsErrorTest: XCTestCase {
    
    func testGetInvalideTextfIELD() {
        let error = NewsError.invalidField
        XCTAssertEqual(error.localizedDescription, "Le text n'est pas valide")
    }
    func testGetShearchFieldEmpty() {
        let error = NewsError.fieldEmpty
        XCTAssertEqual(error.localizedDescription, "Oups... Ce champ ne peut pas être vide")
    }
    func testGetNoNewsFound() {
        let error = NewsError.noNewsFound
        XCTAssertEqual(error.localizedDescription, "Oups... Nous n'avons rien trouver pour cette recherche.")
    }
    func testGetPageLimit() {
        let error = NewsError.pageLimit
        XCTAssertEqual(error.localizedDescription, "Sorry you have reached the limit of page to consult")
    }
    func testGetUnkowError() {
        let error = NewsError.uknowError
        XCTAssertEqual(error.localizedDescription, "Une erreur inconnue est survenue")
    }
    
}
