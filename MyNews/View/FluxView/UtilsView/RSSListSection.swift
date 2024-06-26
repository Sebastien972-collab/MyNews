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
    
    var body: some View {
        Section(content: {
            ForEach(linkManager.fluxLinks, id: \.self) { link in
                if link.status == status {
                    Text(link.link)
                }
                
            }
            .onDelete(perform: { indexSet in
                linkManager.removeLink(indexSet)
            })
        }, header: {
                Text(header)
        })
    }
}

#Preview {
    List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
        RSSListSection(linkManager: LinkManager(), header: "Pending", status: .pending)
    }
}
