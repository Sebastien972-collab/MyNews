//
//  HomeVMTest.swift
//  MyNewsTests
//
//  Created by Sébastien DAGUIN on 17/04/2023.
//

import XCTest
import SJDKitToolBox
@testable import MyNews

final class HomeVMTest: XCTestCase {
    var homeVm = HomeVM(service: NewsService(session: NewsSessionFake(fakeResponse: Result.success(FakeResponseData.correctData))))
    
    func testGetBreakingNews() {
        homeVm.getBreakingNews()
        XCTAssertTrue(homeVm.breakingNews.isNotEmpty)
        
    }
    
    func testGetAResponseError() {
        let newHomeView = HomeVM(service: NewsService(session: NewsSessionFake(fakeResponse: Result.failure(FakeResponseData.responseError))))
        
        XCTAssertEqual(newHomeView.newsError as! NewsError, NewsError.uknowError )
    }

}
