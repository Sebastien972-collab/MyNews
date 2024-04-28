//
//  BookMarkView.swift
//  MyNews
//
//  Created by Sebby on 10/07/2023.
//

import SwiftUI

struct BookMarkView: View {
    @EnvironmentObject var favoriteNewsVm: FavoriteNewsManager
    var body: some View {
        NavigationStack {
            ListArticleView(newsManger: favoriteNewsVm, title: "BookMark")
                .alert(favoriteNewsVm.newsError.localizedDescription, isPresented: $favoriteNewsVm.showError, actions: {
                    Button(role: .cancel, action: {}) {
                        Text("Ok")
                    }
                })
        }
    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookMarkView()
    }
}
