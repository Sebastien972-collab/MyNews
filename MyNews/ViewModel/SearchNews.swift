//
//  SeachNews.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation

class SearchNews: ObservableObject {
    static var preview = SearchNews(service: .shared )
    private var previousResearch: String = ""
    @Published var search: String = ""
    @Published var news: [Article] = []
    @Published var newsError: Error = NewsError.uknowError
    @Published var showError : Bool = false
    @Published var inProgress : Bool = false
    @Published var isComplete : Bool = false
    @Published var page : Int = 1
     var service: NewsService = NewsService.shared
    
    
    init(service: NewsService) {
        self.service = service
    }
    
    func launchSearch() {
        inProgress = true
        guard !search.isEmpty else {
            launchError(NewsError.invalidField)
            return
        }
        news.removeAll()
        previousResearch = search
        service.launchSearch(search: search, page: page, callback: handle)
    }
    
    func nextPage() {
        inProgress = true
        print("Next page de la recherche = \(previousResearch)")
        guard page < 10 else {
            launchError(NewsError.pageLimit)
            page = 1
            return
        }
        page += 1
        service.launchSearch(search: previousResearch, page: page, callback: handle)
        print("Nombre d'element dans news \(news.count)")
    }
    
    func addNews(news: [Article]) -> [Article] {
        var newsToReturn: [Article] = []
        for new in news {
            if new.urlToImage != nil {
                newsToReturn.append(new)
            }
        }
        return newsToReturn
    }
    
    func resetPage() {
        page = 1
    }
     func launchError(_ error: Error) {
        newsError = error
        showError = true
        inProgress = true
    }

    func handle(success: Bool, news: [Article]?, error: Error?) {
        guard success, let news = news, error == nil else {
            launchError(error ?? NewsError.uknowError)
            return
        }
        let nextNews = addNews(news: news)
        guard !nextNews.isEmpty else {
            launchError(NewsError.noNewsFound)
            return
        }
        for new in nextNews {
            self.news.append(new)
        }
        inProgress = false 
        if page == 1 {
            self.isComplete = true
            search.removeAll()
        }
        
    }
}
