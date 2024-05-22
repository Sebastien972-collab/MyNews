//
//  SeachNews.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation

class SearchNewsManager: ObservableObject {
    enum Selection: String, CaseIterable {
        case suggestion = "Suggestions"
        case recent = "Récent"
    }
    @Published var selection: Selection = Selection.suggestion
    static var preview = SearchNewsManager(service: .shared )
    var previousResearch: String = ""
    @Published var search: String = ""
    @Published var news: [Article] = []
    @Published var newsError: Error = NewsError.uknowError
    @Published var showError: Bool = false
    @Published var inProgress: Bool = false
    @Published var isComplete: Bool = false
    @Published var page : Int = 1
    @Published var recentSearchs: [String] = SearchHistory.shared.all
    var service: NewsService = NewsService.shared
    private let history: SearchHistory = SearchHistory.shared
    // For sharing
    @Published var itemsForSharings: [Any] = []
    @Published var isSharing: Bool = false
    
    
    init(service: NewsService) {
        self.service = service
    }
    
    func launchSearch() {
        inProgress = true
        if !recentSearchs.contains(search) {
            recentSearchs.append(search)
        }
        guard !search.isEmpty else {
            launchError(NewsError.invalidField)
            return
        }
        news.removeAll()
        previousResearch = search
        service.launchSearch(search: search, page: page, callback: handle)
        if search != "Recommendations" {
            do {
                try history.saveHistory(search: search)
            } catch  {
                print(error.localizedDescription)
            }
        }
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
        let newsSorted = newsToReturn.sorted { $0.publishedAt > $1.publishedAt }
        return newsSorted
    }
    func remove(_ search: String) {
        for (index, recentSearch) in recentSearchs.enumerated() {
            if search == recentSearch {
                recentSearchs.remove(at: index)
                do {
                    try history.removeElementInHistory(search: search)
                } catch  {
                    print(error.localizedDescription)
                }
                print(recentSearch + " Removed")
            }
        }
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
        let nextNewsSorted =  nextNews.sorted { $0.publishedAt > $1.publishedAt }
        guard !nextNews.isEmpty else {
            launchError(NewsError.noNewsFound)
            return
        }
        for new in nextNewsSorted {
            self.news.append(new)
        }
        inProgress = false 
        if page == 1 {
            self.isComplete = true
            search.removeAll()
        }
    }
    func refresh() {
        news.removeAll()
        launchSearch()
    }
}
