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
    let STORAGE_KEY: String = "SPAGHETTI_DATA_STORAGE_KEY"
    var pasteItems: [PasteItem]!
    var pinnedItems: [PasteItem] {
        pasteItems.filter { $0.isPinned }
    }
    var onlyHistorItems: [PasteItem] {
        pasteItems.filter { !$0.isPinned }
    }
    
    var fileURL: URL {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("there is no way!")
        }
        let fileUrl = path.appendingPathComponent("data.json")
        return fileUrl
    }
    
    var maxNumerOfItems: Int = 100
    
    init(_ pasteItems: [PasteItem]) {
        self.pasteItems = pasteItems
    }
    
    func add(_ item: PasteItem) {
        if isItemPinned(item) {
            return
        }
        
        remove(item)
        pasteItems.append(item)
        
        if self.onlyHistorItems.count > self.maxNumerOfItems {
            if let index = pasteItems.firstIndex(where: { !$0.isPinned }) {
                pasteItems.remove(at: index)
            }
        }
    }
    
    func isItemPinned(_ item: PasteItem) -> Bool {
        pinnedItems.contains { $0.value == item.value }
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
        saveItems()
    }
    
    func encode() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(pasteItems)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch {
            print(error)
        }
        return nil
    }
    
    func decode(json: String) -> [PasteItem] {
        do {
            let decodedItems = try JSONDecoder().decode([PasteItem].self, from: json.data(using: .utf8)!)
            return decodedItems
        } catch { print(error) }
        return []
    }
    
    func saveItems () {
        if let json = encode() {
            do {
                try json.write(to: fileURL, atomically: true, encoding: .utf8)
            }
            catch { print(error) }
        }
    }
    
    func loadItems() {
        do {
            let loadedText = try String(contentsOf: fileURL, encoding: .utf8)
            pasteItems = decode(json: loadedText)
        }
        catch {
            print(error)
        }
    }
    
}
