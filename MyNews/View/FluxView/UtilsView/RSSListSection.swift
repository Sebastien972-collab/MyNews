//
//  RSSListSection.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import SwiftUI

struct RSSListSection: View {
    @ObservedObject var linkManager: LinkManager
    let header: String
    let status: Link.StatusLink
    
    // Filtrage des liens pour cette section
    private var filteredLinks: [Link] {
        linkManager.fluxLinks.filter { $0.status.rawValue == status.rawValue}
    }
    
    var body: some View {
        if !filteredLinks.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                // Header custom (Liquid Style)
                Text(header)
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .padding(.leading, 10)
                
                // Conteneur de la liste en verre
                VStack(spacing: 0) {
                    ForEach(filteredLinks, id: \.self) { link in
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.blue.opacity(0.7))
                                    .font(.footnote)
                                
                                Text(link.status.rawValue)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption2)
                                    .foregroundColor(.secondary.opacity(0.4))
                            }
                            .padding()
                            .background(.ultraThinMaterial.opacity(0.5))
                            
                            // Divider discret entre les lignes
                            if link != filteredLinks.last {
                                Divider()
                                    .padding(.leading, 45)
                                    .opacity(0.3)
                            }
                        }
                        // Support du balayage pour supprimer (Swipe to Delete)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = linkManager.fluxLinks.firstIndex(of: link) {
                                    linkManager.removeLink(IndexSet(integer: index))
                                }
                            } label: {
                                Label("Supprimer", systemImage: "trash")
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
            }
            .padding(.bottom, 20)
        }
    }
}

