//
//  Link.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import Foundation

struct Link: Hashable, Equatable {
    enum StatusLink: String, Hashable, CaseIterable {
    case pending, checked, bad, unapproved
    }
    let link : String
    var status: StatusLink = .pending
    
    static func ==(lhs: Link, rhs: Link) -> Bool {
            return lhs.link == rhs.link
        }
}
