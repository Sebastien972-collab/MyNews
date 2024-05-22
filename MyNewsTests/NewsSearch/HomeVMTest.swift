//
//  HomeVMTest.swift
//  MyNewsTests
//
//  Created by Sébastien DAGUIN on 17/04/2023.
//

import XCTest
@testable import MyNews

final class HomeVMTest: XCTestCase {
    var homeVm = HomeViewManager(service: NewsService(session: NewsSessionFake(fakeResponse: Result.success(FakeResponseData.correctData))))
    
    func testGetBreakingNews() {
        XCTAssertFalse(homeVm.breakingNews.isEmpty)
        
    }
    
    func testGetAResponseError() {
        let newHomeView = HomeViewManager(service: NewsService(session: NewsSessionFake(fakeResponse: Result.failure(FakeResponseData.responseError))))
        
        XCTAssertEqual(newHomeView.newsError as! NewsError, NewsError.uknowError )
    }
    
    func testLaunch() {
        homeVm.previousResearch.removeAll()
        homeVm.launchSearch()
        XCTAssertTrue(homeVm.previousResearch == "recommandation")
        XCTAssertFalse(homeVm.news.isEmpty)
    }
}
