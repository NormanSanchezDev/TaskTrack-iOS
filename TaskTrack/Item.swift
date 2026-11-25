//
//  Item.swift
//  TaskTrack
//
//  Created by Norman Sánchez on 25/11/26.
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
