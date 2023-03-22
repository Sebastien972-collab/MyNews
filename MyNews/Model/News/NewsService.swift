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
    private var newsSession = NewsSession()
    init(recipeSession: NewsSession) {
        self.newsSession = recipeSession
        
    }
    
    func getNews(callback: @escaping (Bool, [Article]?, Error?) -> Void)  {
        //        let ingredientsForUrl = Utils.clearForUrl(ingredients)
        let baseUrl = URL(string: "https://newsapi.org/v2/everything?q=breaking%20news&apiKey=c20fd58be9174ab5941ec7a08eeb88df&language=fr")!
        print(baseUrl)
        launchSession(baseUrl: baseUrl) { success, news, error in
            callback(success, news, error)
        }
        
    }
    func launchSearch(search: String, callback: @escaping (Bool, [Article]?, Error?) -> Void)  {
        //        let ingredientsForUrl = Utils.clearForUrl(ingredients)
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<BaseUrl>>>>>>>>>>>>>>>>>>>>>>>>")
        print(search)
        let baseUrl = URL(string: "https://newsapi.org/v2/everything?q=\(search.utf8)&apiKey=c20fd58be9174ab5941ec7a08eeb88df&language=fr")!
        
        launchSession(baseUrl: baseUrl) { success, news, error in
            callback(success, news, error)
        }
        
    }
    
    func getBreakingNews(callback: @escaping (Bool, [Article]?, Error?) -> Void) {
        let baseUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=fr&apiKey=c20fd58be9174ab5941ec7a08eeb88df")!
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
