//
//  FavoriteNewsTest.swift
//  MyNewsTests
//
//  Created by Sebby on 24/01/2024.
//

import XCTest
@testable import MyNews
final class FavoriteNewsTest: XCTestCase {
    var favoriteNews: FavoriteNews!
    
    override func setUp() {
        favoriteNews = FavoriteNews(persistenceController: PersistenceController(inMemory: true))
    }
    
    func testSetUp() {
        XCTAssertTrue(favoriteNews.all.isEmpty)
    }
    
    func testSaveAtNews() {

        XCTAssertNoThrow(try favoriteNews.saveArticle(article: .preview))
        XCTAssertFalse(favoriteNews.all.isEmpty)
    }
    
    func testSaveASavedNews() {
        do {
            try favoriteNews.saveArticle(article: Article.preview)
        } catch  {
            XCTAssertNil(error)
        }
        do {
            try favoriteNews.saveArticle(article: Article.preview)
        } catch  {
            XCTAssertNil(error)
        }
        
        XCTAssertTrue(favoriteNews.all.isEmpty)
    }
    
    func testRemoveAExitingNews() {
        do {
            try favoriteNews.saveArticle(article: .preview)
        } catch  {
            XCTAssertNil(error)
        }
        
        do {
            try favoriteNews.removeElementInFavorite(article: .preview)
        } catch  {
            XCTAssertNil(error)
        }
    }
    
    

}
