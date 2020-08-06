//
//  ViewController.swift
//  StoryboardApp
//
//  Created by Jack Enqvist on 2020-06-25.
//  Copyright © 2020 Jack Enqvist. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var inputTextField: NSSearchField!
    override var acceptsFirstResponder: Bool { true }
    
    
    var history: [String] = ["hello", "Balloo"]
    
    var reversedHistory: [String] {
        history.reversed()
    }
    var filteredHistory: [String] {
        history.filter { $0.lowercased().contains(inputTextField.stringValue.lowercased()) || inputTextField.stringValue == "" }
    }
    
    func addHistory (history: [String]) {
        self.history = history
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    func appendToHistory (item: String) {
        print("appending \(item) to \(self.history)")
        self.history.append(item)
        if let tv = tableView {
            print("============== reloading data? \(self.history)")
            tv.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(self.history)
        // Do any additional setup after loading the view.
    }
    
    func controlTextDidChange(_ obj: Notification) {
        print("text changed: \(inputTextField.stringValue) | \(filteredHistory)")
        tableView.reloadData()
    }
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        print("performKeyEquivalent \(event)")
        return true
    }
    
    override func keyUp(with event: NSEvent) {
//        print("\(event.keyCode)")
        print("key pressed: \(event)")
        
        if event.keyCode == 36 { // Enter Key
            actuallyPaste()
        }
    }
    
    @objc func actuallyPaste() {
        let currentSelectionIndex = max(self.tableView.selectedRow, 0)
        let currentSelection = self.reversedHistory[currentSelectionIndex % reversedHistory.count]
       
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(currentSelection, forType: .string)
    }
    
    @objc func delete(button: NSButton) {
        print("\(button.tag) \(reversedHistory[button.tag])")
//        need to remove it from the source (in appdelegate)
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return reversedHistory.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let currentHistoryItem : String = reversedHistory[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "DataColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "DataCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = currentHistoryItem.trimmingCharacters(in: [" "])
            cellView.toolTip = currentHistoryItem
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "RemoveColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "RemoveCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else {
                return nil }
            let button = NSButton(title: "X", target: self, action: #selector(delete))
            button.tag = row
            button.sizeToFit()
            cellView.addSubview(button)

            print(" here -> \(NSBackspaceCharacter) <-")
            button.keyEquivalent = "\(NSBackspaceCharacter)"
        

            return cellView
        } else {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ButtonCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            let button = NSButton(title: "copy", target: self, action: #selector(actuallyPaste))
            button.sizeToFit()
            cellView.addSubview(button)
            
            button.keyEquivalent = "\r"
            
            return cellView
        }
       
    }
}

