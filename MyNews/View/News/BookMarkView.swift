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
            ListArticleView(newsManger: favoriteNewsVm)
                .onAppear() {
                    favoriteNewsVm.refresh()
                }
                .alert(favoriteNewsVm.newsError.localizedDescription, isPresented: $favoriteNewsVm.showError, actions: {
                    Button(role: .cancel, action: {}) {
                        Text("Ok")
                    }
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            favoriteNewsVm.removeAll()
                        } label: {
                            Image(systemName: "trash")
                        }

                    }
                }
                
        }
    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookMarkView()
    }
}
