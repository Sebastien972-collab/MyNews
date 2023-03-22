//
//  SeachNews.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation

class SearchNews: ObservableObject {
    static var shared = SearchNews()
    private init(){}
    @Published var search: String = ""
    @Published var breakingNews: [Article] = [.preview,.preview,.preview,.preview,.preview,.preview]
    @Published var news: [Article] = [.preview,.preview,.preview,.preview,.preview,.preview]
    @Published var newsError: Error = NewsError.uknowError
    @Published var showError : Bool = false
    @Published var inProgress : Bool = false
    @Published var isComplete : Bool = false
    
    func getBreakingNews() {
        NewsService.shared.getNews { succees , news, error in
            guard succees, let news = news, error == nil else {
                print(error?.localizedDescription ?? "Unknow error")
                self.newsError = error ?? NewsError.uknowError
                self.showError.toggle()
                return
            }
            self.breakingNews = news
            
            
            
            
        }
    }
    func launchSearch(_ theme: String?) {
        print("Launch search")
        if let theme = theme {
            NewsService.shared.launchSearch(search: theme, callback: handle)
        } else {
            NewsService.shared.launchSearch(search: search, callback: handle)
        }
    }
    
    private func handle(success: Bool, news: [Article]?, error: Error?) {
        guard success, let news = news, error == nil else {
            self.newsError = error ?? NewsError.uknowError
            self.showError.toggle()
            return
        }
        
        self.news = news
        guard !self.news.isEmpty else {
            self.newsError = NewsError.noRecipeFound
            self.showError.toggle()
            return
        }
        print(self.news.count)
        self.isComplete.toggle()
        
        self.inProgress.toggle()
    }
}
