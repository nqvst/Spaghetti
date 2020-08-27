//
//  PasteItem.swift
//  Spaghetti
//
//  Created by Jack Enqvist on 2020-08-24.
//  Copyright © 2020 Jack Enqvist. All rights reserved.
//

import Foundation

struct PasteItem {
    var value: String
    var isPinned: Bool = false {
        didSet {
            print("PasteItem.swift > i got toggled!", oldValue, " -> ", isPinned)
        }
    }
    
    init(_ value: String) {
        self.value = value
    }
    
    init(_ value: String, pinned isPinned: Bool) {
        self.value = value
        self.isPinned = isPinned
    }
    
    mutating func toggleIsPinned() -> Void {
        self.isPinned.toggle()
    }
}
