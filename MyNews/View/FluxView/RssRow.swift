//
//  RssRow.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import SwiftUI

struct RssRow: View {
    let rssItem: RSSItem
    var body: some View {
        VStack(alignment: .leading) {
            Text(rssItem.title)
                .font(.headline)
                .lineLimit(1)
            Text(rssItem.description)
                .font(.subheadline)
                .lineLimit(3)
            Divider()
            Text("- \(rssItem.hostname) - \(rssItem.dateFr)")
                .font(.footnote)
        }
        .foregroundStyle(.black)
        .frame(maxHeight: 150)
        .padding()
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    RssRow(rssItem: .preview)
}
