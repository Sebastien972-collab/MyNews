//
//  FavoriteNewsTest.swift
//  MyNewsTests
//
//  Created by Sebby on 23/01/2024.
//

import XCTest
@testable import MyNews

final class FavoriteNewsManagerTest: XCTestCase {
    
    var favoriteNewsManager: FavoriteNewsManager!
    
    
    override func setUp() {
        super.setUp()
        favoriteNewsManager = FavoriteNewsManager(service: NewsService(session: NewsSessionFake(fakeResponse: Result.success(FakeResponseData.correctData))), favoriteNews: FavoriteNews(persistenceController: PersistenceController(inMemory: true)))
    }
    
    func test() {
        XCTAssertTrue(favoriteNewsManager.news.isEmpty)
    }
    func testGivenAArticleToSave() {
        favoriteNewsManager.saveRecipe(Article.preview)
        XCTAssertFalse(favoriteNewsManager.news.isEmpty)
        print("Le nombre de news est \(favoriteNewsManager.news.count)")
        XCTAssertTrue(favoriteNewsManager.news[0].title == Article.preview.title)
    }
    func testGivenAArticleSaved() {
        favoriteNewsManager.saveRecipe(Article.preview)
        XCTAssertFalse(favoriteNewsManager.news.isEmpty)
        print("Le nombre de news est \(favoriteNewsManager.news.count)")
        XCTAssertTrue(favoriteNewsManager.news[0].title == Article.preview.title)
        favoriteNewsManager.saveRecipe(Article.preview)
        XCTAssertTrue(favoriteNewsManager.news.isEmpty)
    }
    
    func testGivenAarticleSaveIfIsFavorite() {
        favoriteNewsManager.saveRecipe(.preview)
        XCTAssert(favoriteNewsManager.isFavorite(.preview))
    }
    
}
