//
//  NewsService.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation

class NewsService {
    static var shared = NewsService()
    private init(){}
    private var newsSession: NewsSession = NewsSession()
    
    init(session: NewsSession) {
        self.newsSession = session
        
    }
    func launchSearch(search: String, page: Int, callback: @escaping (Bool, [Article]?, Error?) -> Void)  {
        let searchToUrl = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<BaseUrl>>>>>>>>>>>>>>>>>>>>>>>>")
        let baseUrl = URL(string: "https://newsapi.org/v2/everything?q=\(searchToUrl)&apiKey=3c9b682448ef413499e57b61c45dfc9b&language=fr&page=\(page)&pageSize=10")!
        print(baseUrl)
        launchSession(baseUrl: baseUrl) { success, news, error in
            callback(success, news, error)
        }
    }
    
    private func launchSession(baseUrl: URL, callback: @escaping (Bool, [Article]?, Error?) -> Void) {
        newsSession.session(url: baseUrl) { result in
            switch result {
            case .success (let data):
                do {
                    let decoder = JSONDecoder()
                    let product = try decoder.decode(News.self, from: data)
                    callback(true, product.articles, nil)
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
