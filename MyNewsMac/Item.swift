//
//  Item.swift
//  MyNewsMac
//
//  Created by Sebby on 20/05/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
