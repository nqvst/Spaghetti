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
    var pinnedItems: [PasteItem] {
        pasteItems.filter { $0.isPinned }
    }
    var onlyHistorItems: [PasteItem] {
        pasteItems.filter { !$0.isPinned }
    }
    
    var maxNumerOfItems: Int = 100
    
    init(_ pasteItems: [PasteItem]) {
        self.pasteItems = pasteItems
    }
    
    func add(_ item: PasteItem) {
        remove(item)
        pasteItems.append(item)
        
        if self.onlyHistorItems.count > self.maxNumerOfItems {
            if let index = pasteItems.firstIndex(where: { !$0.isPinned }) {
                pasteItems.remove(at: index)
            }
        }
    }
    
    func remove(_ itemToRemove: PasteItem) {
        self.pasteItems.removeAll { item in
            itemToRemove.value == item.value
        }
    }
    
    func addToPinned(_ item: PasteItem) {
        if let index = pasteItems.firstIndex(where: { $0.value == item.value }) {
            pasteItems[index].toggle()
        }
        
        if self.pinnedItems.count > self.maxNumerOfItems {
            if let index = pasteItems.firstIndex(where:{ $0.isPinned }) {
                pasteItems.remove(at: index)
            }
        }
    }
    
    
    func removePinned(_ itemToRemove: PasteItem) {
        if let index = pasteItems.firstIndex(where:{ $0.value == itemToRemove.value }) {
           pasteItems[index].toggle()
       }
    }
    
    func clear() {
        pasteItems.removeAll()
    }
    
}
