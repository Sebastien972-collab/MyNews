//
//  HomeVM.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 16/04/2023.
//

import Foundation

class HomeViewManager: SearchNewsManager {
    @Published var breakingNews: [Article] = []
    private var isBreakingNews = false
    
    private func getBreakingNews() {
        inProgress = true
        service.launchSearch(search: "france", page: page) { success , news, error in
            guard success, let news = news, error == nil else {
                return self.launchError(error ?? NewsError.uknowError)
            }
            self.breakingNews = self.addNews(news: news)
            
            
        }
    }
    override func launchSearch() {
        getBreakingNews()
        search = "recommandation"
        super.launchSearch()
        nextPage()
    }
    
    override func refresh() {
        super.news.removeAll()
        breakingNews.removeAll()
        getBreakingNews()
        launchSearch()
    }
}
