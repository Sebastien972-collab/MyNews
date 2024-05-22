//
//  RssRow.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import SwiftUI

struct RssRow: View {
    let rssItem: RSSItem
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(rssItem.title)
                .font(.headline)
                .lineLimit(1)
                .padding(.bottom)
            Text(rssItem.descriptionDecode)
                .font(.subheadline)
                .lineLimit(3)
            Divider()
            Text("- \(rssItem.hostname) - \(rssItem.dateFr)")
                .font(.footnote)
        }
        .foregroundStyle(colorScheme == .dark ? .white : .black)
        .frame(maxHeight: 150)
        .padding()
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    RssRow(rssItem: .preview)
}
