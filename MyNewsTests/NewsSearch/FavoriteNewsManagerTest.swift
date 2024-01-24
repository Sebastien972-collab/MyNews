//
//  FavoriteNewsTest.swift
//  MyNewsTests
//
//  Created by Sebby on 23/01/2024.
//

import XCTest
@testable import MyNews

final class FavoriteNewsManagerTest: XCTestCase {
    var favoriteNews = FavoriteNewsManager(service: NewsService(session: NewsSessionFake(fakeResponse: Result.success(FakeResponseData.correctData))))
    
    func testGivenACorrectData() {
        favoriteNews.saveRecipe(Article.preview)
        
    }

}
