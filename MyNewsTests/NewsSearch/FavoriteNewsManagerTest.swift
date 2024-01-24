//
//  FavoriteNewsTest.swift
//  MyNewsTests
//
//  Created by Sebby on 23/01/2024.
//

import XCTest
@testable import MyNews

final class FavoriteNewsManagerTest: XCTestCase {
    
    var favoriteNews: FavoriteNewsManager!
    
    
    override func setUp() {
        super.setUp()
        favoriteNews = FavoriteNewsManager(service: NewsService(session: NewsSessionFake(fakeResponse: Result.success(FakeResponseData.correctData))), favoriteNews: FavoriteNews(persistenceController: PersistenceController(inMemory: true)))
    }
    
    func test() {
        XCTAssertTrue(favoriteNews.news.isEmpty)
    }
    func testGivenAArticleToSave() {
        favoriteNews.saveRecipe(Article.preview)
        XCTAssertFalse(favoriteNews.news.isEmpty)
        print("Le nombre de news est \(favoriteNews.news.count)")
        XCTAssertTrue(favoriteNews.news[0].title == Article.preview.title)
    }
    
    func testGivenAarticleSaveIfIsFavorite() {
        favoriteNews.saveRecipe(.preview)
        XCTAssert(favoriteNews.isFavorite(.preview))
    }
    
}
