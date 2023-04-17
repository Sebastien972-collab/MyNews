//
//  MyNewsTests.swift
//  MyNewsTests
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import XCTest
@testable import MyNews

final class MyNewsServiceTest: XCTestCase {
    func testGetAcorrectResponse() {
        let newsSession = NewsSessionFake(fakeResponse: Result.success(FakeResponseData.correctData) )
        let newsService = NewsService(session: newsSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        newsService.launchSearch(search: "", page: 1) { success , article, error in
            XCTAssertTrue(success)
            XCTAssertNotNil(article)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    func testGetAIncorrectResponse() {
        let newsSession = NewsSessionFake(fakeResponse: Result.success(FakeResponseData.incorrectData) )
        let newsService = NewsService(session: newsSession)
        let expectation = XCTestExpectation(description: "Wait for queue change")

        newsService.launchSearch(search: "", page: 1) { success , article, error in
            XCTAssertFalse(success)
            XCTAssertNil(article)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetASuccessRequestButAIncorrectDataResponse() {
        let newsSession = NewsSessionFake(fakeResponse: Result.success(FakeResponseData.incorrectData))
        let newsService = NewsService(session: newsSession)
        newsService.launchSearch(search : "", page: 1) { success, article, error in
            XCTAssertFalse(success)
            XCTAssertNil(article)
            XCTAssertNotNil(error)
        }
    }

    func testGetAResultFailure() {
        let newsSession = NewsSessionFake(fakeResponse: Result.failure(FakeResponseData.responseError))
        let newsService = NewsService(session: newsSession)

        newsService.launchSearch(search: "", page: 1) { success, article, error in
            XCTAssertFalse(success)
            XCTAssertNil(article)
            XCTAssertNotNil(error)
        }
    }

    func testFirstArticle() {
        let newsSession = NewsSessionFake(fakeResponse: Result.success(FakeResponseData.correctData) )
        let newsService = NewsService(session: newsSession)

        newsService.launchSearch(search: "", page: 1) { success , article, error in

            let firstArticle = article![0]
            XCTAssertEqual(firstArticle.title, "Ligue 1 : le PSG chute à domicile face à Rennes")
            XCTAssertEqual(firstArticle.author, "Le Monde")


        }
    }
}
