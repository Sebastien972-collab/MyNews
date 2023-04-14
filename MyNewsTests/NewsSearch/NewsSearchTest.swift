//
//  RecipeSearchTest.swift
//  MyNewsTests
//
//  Created by Sébastien DAGUIN on 24/03/2023.
//

import XCTest
import Alamofire
@testable import MyNews

final class SearchNewsTest: XCTestCase {
    var searchNews = SearchNews(service: NewsService(recipeSession: NewsSessionFake(fakeResponse: Result.success(FakeResponseData.correctData))))
    
    func testSearchFieldEmpty() {
        searchNews.search = ""
        searchNews.launchSearch(nil)
        XCTAssertEqual(searchNews.newsError as! NewsError, NewsError.invalidField)
    }
    func testUserNotEnterThemeToSearch()  {
        searchNews.search = "Superman"
        searchNews.launchSearch("")
        XCTAssertEqual(searchNews.newsError as! NewsError, NewsError.invalidField)
    }
    func testUserEnterAValidRecherche()  {
        searchNews.news.removeAll()
        searchNews.search = "49.3"
        searchNews.launchSearch(nil)
        XCTAssertTrue(searchNews.news.isNotEmpty)
        
    }
    func testNextPageWithPage10() {
        searchNews.page = 10
        searchNews.nextPage()
        
        XCTAssertEqual(searchNews.newsError as! NewsError, NewsError.pageLimit)
    }
    
    func test5()  {
        searchNews.page = 3
        searchNews.nextPage()
        XCTAssertEqual(searchNews.page, 4)
    }
    
    func testGivenAResponseWithDataIncorrect() {
        let newSearchNews = SearchNews(service: NewsService(recipeSession: NewsSessionFake(fakeResponse: Result.success(FakeResponseData.incorrectData))))
        
        newSearchNews.launchSearch(nil)
        XCTAssertTrue(newSearchNews.news.isEmpty)
        XCTAssertNotEqual(newSearchNews.newsError as! NewsError, NewsError.uknowError)
        XCTAssertTrue(newSearchNews.showError)
    }
    
    func testGivenAResponseFailure() {
        let newSearchNews = SearchNews(service: NewsService(recipeSession: NewsSessionFake(fakeResponse: Result.failure(FakeResponseData.responseError))))
        
        newSearchNews.launchSearch("")
        XCTAssertNotEqual(newSearchNews.newsError as! NewsError, NewsError.uknowError)
        XCTAssertTrue(newSearchNews.showError)
    }
}
