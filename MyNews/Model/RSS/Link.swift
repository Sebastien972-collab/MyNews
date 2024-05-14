//
//  Link.swift
//  MyNews
//
//  Created by Sebby on 14/05/2024.
//

import Foundation

struct Link: Hashable, Equatable {
    enum StatusLink {
    case pending, checked, bad, unapproved
    }
    let link : String
    var status: StatusLink = .pending
    
    mutating func changeStatusTo(_ newStatus: StatusLink) {
        status = newStatus
    }
    
}
