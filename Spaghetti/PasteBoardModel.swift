//
//  PasteBoardModel.swift
//  Spaghetti
//
//  Created by Jack Enqvist on 2020-08-24.
//  Copyright © 2020 Jack Enqvist. All rights reserved.
//

import Foundation
import Cocoa

class PasteBoardModel {
    var pasteItems: [PasteItem]!
    var pinnedItems: [PasteItem]!
    
    var maxNumerOfItems: Int = 100
    
    init(_ pasteItems: [PasteItem], _ pinnedItems: [PasteItem] ) {
        self.pasteItems = pasteItems
        self.pinnedItems = pinnedItems
    }
    
    func addToPastboard(_ item: PasteItem) {
        removeFromHistory(item)
        pasteItems.append(item)
        
        if self.pasteItems.count > self.maxNumerOfItems {
            self.pasteItems.remove(at: 0)
        }
    }
    
    func removeFromHistory(_ itemToRemove: PasteItem) {
        self.pasteItems.removeAll { item in
            itemToRemove.value == item.value
        }
    }
    
    func addToPinned(_ item: PasteItem) {
        removePinned(item)
        
        let newItem = PasteItem(item.value, pinned: true)
        pinnedItems.append(newItem)
        
        if let index = pasteItems.firstIndex(where:{ $0.value == item.value }) {
            pasteItems[index] = newItem
        }
        
        if self.pinnedItems.count > self.maxNumerOfItems {
            self.pinnedItems.remove(at: 0)
        }
    }
    
    func removePinned(_ itemToRemove: PasteItem) {
        self.pinnedItems.removeAll { item in
            itemToRemove.value == item.value
        }
    }
    
    func clear() {
        pasteItems.removeAll()
    }
    
}
