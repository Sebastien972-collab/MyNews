//
//  NewsService.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation

class NewsService {
    static var shared = NewsService()
    private let newsSession: NewsSession
    private let apiKey: String?

    init(session: NewsSession = NewsSession(),
         apiKey: String? = Bundle.main.object(forInfoDictionaryKey: "NewsAPIKey") as? String) {
        self.newsSession = session
        self.apiKey = apiKey
    }
    func launchSearch(search: String, page: Int, callback: @escaping (Bool, [Article]?, Error?) -> Void)  {
        guard let apiKey, !apiKey.isEmpty else {
            callback(false, nil, NewsError.unconfiguredService)
            return
        }
        var components = URLComponents(string: "https://newsapi.org/v2/everything")!
        components.queryItems = [URLQueryItem(name: "q", value: search),
                                 URLQueryItem(name: "apiKey", value: apiKey),
                                 URLQueryItem(name: "language", value: "fr"),
                                 URLQueryItem(name: "page", value: String(page)),
                                 URLQueryItem(name: "pageSize", value: "10")]
        guard let baseUrl = components.url else {
            callback(false, nil, NewsError.invalidField)
            return
        }
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
