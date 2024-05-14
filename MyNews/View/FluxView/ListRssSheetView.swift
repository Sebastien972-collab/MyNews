//
//  ListRssSheetView.swift
//  MyNews
//
//  Created by Sebby on 10/05/2024.
//

import SwiftUI

struct ListRssSheetView: View {
    var links: [String] = ["https://www.journaldunet.com/rss/",
                           "https://www.numerama.com/feed/",
                           "https://www.frandroid.com/feed",
                           "https://www.mac4ever.com/flux/rss/category/iphone"
      ]
    var body: some View {
        List {
            ForEach(links, id: \.self) { link in
                Text(link)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "plus.circle")
                })
            }
        }
    }
}

#Preview {
    NavigationStack {
        ListRssSheetView()
    }
}
