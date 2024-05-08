//
//  FluxService.swift
//  MyNews
//
//  Created by Sebby on 20/04/2024.
//

import Foundation
import SwiftyXMLParser
class FluxService {
    static var shared = FluxService()
    private init(){}
    private var newsSession: NewsSession = NewsSession()
    
    init(session: NewsSession) {
        self.newsSession = session
        
    }
    func launchSearch(search: String, callback: @escaping (Bool, [ItemRss]?, Error?) -> Void)  {
        let searchToUrl = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<BaseUrl>>>>>>>>>>>>>>>>>>>>>>>>")
        let baseUrl = URL(string: "https://www.mac4ever.com/flux/rss/content/all")!
        print(baseUrl)
        launchSession(baseUrl: baseUrl) { success, news, error in
            print(news![0].description)
            callback(success, news, error)
        }
    }
    
    private func launchSession(baseUrl: URL, callback: @escaping (Bool, [ItemRss]?, Error?) -> Void) {
//        newsSession.session(url: baseUrl) { result in
//            switch result {
//            case .success (let data):
//                do {
//                    let product = XML.parse(data)
//                    let elem = product.element
//                    let channel = elem["]
                    
                    
//                    callback(true, , nil)
                } catch  {
                    print(error.localizedDescription)
                    callback(false, nil, error)
                }
            case .failure(let failure):
                callback(false, nil, failure)
            }
        }
    }
}
