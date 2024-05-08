//
//  FluxRss.swift
//  MyNews
//
//  Created by Sebby on 20/04/2024.
//

import Foundation


struct NewsRss: Codable, Hashable {
    let channel: [ItemRss]
    
}
struct ItemRss: Codable, Hashable {
    let title: String
    let link: String
    let description: String
}
