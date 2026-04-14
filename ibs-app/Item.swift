//
//  Item.swift
//  ibs-app
//
//  Created by Franklin Rigoutsos on 4/14/26.
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
