//
//  NewsSessionFake.swift
//  MyNewsTests
//
//  Created by Sébastien DAGUIN on 13/04/2023.
//
import Foundation
import Alamofire
@testable import MyNews

class NewsSessionFake: NewsSession {
    private let fakeResponse : Result<Data, AFError>
    
    init(fakeResponse: Result<Data, AFError>) {
        self.fakeResponse = fakeResponse
    }
    
    override func session(url: URLConvertible, callback: @escaping (Result<Data, AFError>) -> Void) {
        callback(fakeResponse)
    }
}
