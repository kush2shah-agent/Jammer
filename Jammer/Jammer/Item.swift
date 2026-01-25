//
//  Item.swift
//  Jammer
//
//  Created by Kush Shah on 1/25/26.
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
