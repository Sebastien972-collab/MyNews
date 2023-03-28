//
//  SeachNews.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation
import SJDKitToolBox

class SearchNews: ObservableObject {
    static var shared = SearchNews()
    private init(){}
    @Published var search: String = ""
    private var previousResearch: String = ""
    @Published var breakingNews: [Article] = []
    private var isBreakingNews = false
    @Published var news: [Article] = []
    @Published var newsError: Error = NewsError.uknowError
    @Published var showError : Bool = false
    @Published var inProgress : Bool = false
    @Published var isComplete : Bool = false
    @Published var page : Int = 1
    private var service: NewsService = NewsService.shared
    
    
    init(service: NewsService) {
        self.service = service
    }
    
    func getBreakingNews() {
        self.isBreakingNews = true
        service.getNews(callback: handle)
    }
    func launchSearch(_ theme: String?) {
        print("Launch search")
        print(search)
        
        guard theme != nil || search.isNotEmpty else {
            newsError = NewsError.invalidField
            showError.toggle()
            return
        }
        previousResearch = search
        if let theme = theme {
            guard theme.isNotEmpty else {
                launchError(NewsError.invalidField)
                return
            }
            previousResearch = theme
            service.launchSearch(search: theme, page: page, callback: handle)
        } else {
            previousResearch = search
            service.launchSearch(search: search, page: page, callback: handle)
        }
        
        if page < 2 {
            self.isComplete.toggle()
        }
    }
    
    func nextPage() {
        print("Next page de la recherche = \(previousResearch)")
        guard page < 10 else {
            launchError(NewsError.pageLimit)
            page = 1
            return
        }
        page += 1
        launchSearch(previousResearch)
        
    }
    
    private func launchError(_ error: Error) {
        newsError = error
        showError = true
    }
    
    private func handle(success: Bool, news: [Article]?, error: Error?) {
        guard success, let news = news, error == nil else {
            launchError(error ?? NewsError.uknowError)
            return
        }
        
        guard !news.isEmpty else {
            launchError(NewsError.noNewsFound)
            return
        }
        if page == 1 {
            self.news.removeAll()
        }
        if isBreakingNews {
            self.breakingNews = news
            self.isBreakingNews = false
        } else {
            for new in news {
                if new.urlToImage != nil {
                    self.news.append(new)
                }
            }
        }
        self.inProgress.toggle()
    }
}
