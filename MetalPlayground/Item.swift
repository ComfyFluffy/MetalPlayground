//
//  Item.swift
//  MetalPlayground
//
//  Created by i on 10/21/23.
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
