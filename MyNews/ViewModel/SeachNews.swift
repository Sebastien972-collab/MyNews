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
    @Published var news: [Article] = []
    @Published var newsError: Error = NewsError.uknowError
    @Published var showError : Bool = false
    @Published var inProgress : Bool = false
    @Published var isComplete : Bool = false
    @Published var page : Int = 1
    
    
    func getBreakingNews() {
        NewsService.shared.getNews { succees , news, error in
            guard succees, let news = news, error == nil else {
                print(error?.localizedDescription ?? "Unknow error")
                self.newsError = error ?? NewsError.uknowError
                self.showError.toggle()
                return
            }
            self.breakingNews = []
            for new in news {
                if new.urlToImage != nil {
                    self.breakingNews.append(new)
                }
            }
        }
    }
    func launchSearch(_ theme: String?) {
        print("Launch search")
        print(search)
        
        guard theme != nil || search.isNotEmpty else {
            newsError = NewsError.fieldEmpty
            showError.toggle()
            return
        }
        previousResearch = search
        if let theme = theme {
            previousResearch = theme
            NewsService.shared.launchSearch(search: theme, page: page, callback: handle)
        } else {
            previousResearch = search
            NewsService.shared.launchSearch(search: search, page: page, callback: handle)
        }
        if page < 2 {
            self.isComplete.toggle()
        }
    }
    
    func nextPage() {
        print("Next page de la recherche = \(previousResearch)")
        guard page <= 10 else {
            newsError = NewsError.noNewsFound
            showError.toggle()
            page = 1
            return
        }
        page += 1
        launchSearch(previousResearch)
        
    }
    
    private func handle(success: Bool, news: [Article]?, error: Error?) {
        guard success, let news = news, error == nil else {
            self.newsError = error ?? NewsError.uknowError
            self.showError.toggle()
            return
        }
        
        guard !news.isEmpty else {
            self.newsError = NewsError.noNewsFound
            self.showError.toggle()
            return
        }
        if page == 1 {
            self.news.removeAll()
        }
        for new in news {
            if new.urlToImage != nil {
                self.news.append(new)
            }
        }
        print(self.news.count)
        self.inProgress.toggle()
    }
}
