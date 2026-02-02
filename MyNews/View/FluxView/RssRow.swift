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
        VStack(alignment: .leading, spacing: 12) {
            // Header : Hostname et Date
            HStack {
                Text(rssItem.hostname.uppercased())
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
                
                Spacer()
                
                Text(rssItem.dateFr)
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            // Titre
            Text(rssItem.title)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            // Description
            Text(rssItem.descriptionDecode)
                .font(.system(.subheadline, design: .rounded))
                .lineLimit(3)
                .foregroundColor(.secondary)
                .lineSpacing(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        // L'effet Liquid Glass
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(LinearGradient(
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing), lineWidth: 1.5)
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    RssRow(rssItem: .preview)
}
