//
//  FakeResponseData.swift
//  MyNewsTests
//
//  Created by Sébastien DAGUIN on 24/03/2023.
//

import Foundation
import Alamofire

class FakeResponseData {
    
    class ResponseError : Error {}
    static let reponseError = AFError.createURLRequestFailed(error: ResponseError())
    
    static let responseOK = HTTPURLResponse(
            url: URL(string: "https://github.com/Sebastien972-collab")!,
            statusCode: 200, httpVersion: nil, headerFields: [:])!
        
        static let responseKO = HTTPURLResponse(
            url: URL(string: "https://github.com/Sebastien972-collab")!,
            statusCode: 500, httpVersion: nil, headerFields: [:])!
        
        // MARK: - Data
        static var correctData: Data {
            let bundle = Bundle(for: FakeResponseData.self)
            let url = bundle.url(forResource: "FakeNews", withExtension: "json")
            let data = try! Data(contentsOf: url!)
            print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>")
            print("Data et passer \(data.count)")
            
            return data
        }
    
    static let incorrectData = "Erreur".data(using: .utf8)!
}
