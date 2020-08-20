//
//  ProgramaticViewController.swift
//  StoryboardApp
//
//  Created by Jack Enqvist on 2020-08-06.
//  Copyright © 2020 Jack Enqvist. All rights reserved.
//

import Cocoa
import SnapKit

class ProgramaticViewController: NSViewController {
    
    var label: NSTextField!
    var tableView: NSTableView!
    var inputTextField: NSSearchField!
    
    var removeItem: (String) -> Void = { (apa) in
        print("FAKE!!!")
    }
    
    var dismissCallback: () -> Void = { () in
        print("FAKE!!!")
    }
    
    var history: [String] = ["hello", "Balloo"]
    
    var reversedHistory: [String] {
        history.reversed()
    }
    
    override var acceptsFirstResponder: Bool { true }
    
    override func loadView() {
        self.view = NSView()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.history)
        
        tableView = NSTableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        let dataCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "DataColumn"))
        
        tableView.addTableColumn(dataCol)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view)
        }
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
    
    func controlTextDidChange(_ obj: Notification) {
        print("text changed: \(inputTextField.stringValue) | \(filteredHistory)")
        tableView.reloadData()
    }

    override func keyUp(with event: NSEvent) {
        print("\(event.keyCode)")
        
        if event.keyCode == 36 { // Enter Key
            actuallyPaste()
        }
        
        if event.keyCode == 125 { // Down
            
        }
        
        if event.keyCode == 126 { // Up
            
        }
    }
    
    @objc func actuallyPaste() {
        let currentSelectionIndex = max(self.tableView.selectedRow, 0)
        let currentSelection = self.reversedHistory[currentSelectionIndex % reversedHistory.count]
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(currentSelection, forType: .string)
        tableView.moveRow(at: self.tableView.selectedRow, to: 0)
        self.dismissCallback()
    }
    
}

extension ProgramaticViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return reversedHistory.count
    }
}

extension ProgramaticViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let currentHistoryItem : String = reversedHistory[row]
        let height: CGFloat = 35.0
        tableView.rowHeight = 35.0
        
        
        let frameRect = NSRect(x: 0, y: 0, width: tableColumn!.width, height: height)
        let tableCellView = ClipDataCell(frame: frameRect, text:  currentHistoryItem.trimmingCharacters(in: [" "]))
        
        return tableCellView
        
    }
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        let currentHistoryItem : String = reversedHistory[row]
        
        switch edge {
        case .leading:
            let copyAction = NSTableViewRowAction(style: .regular, title: "Copy") { (action, row) in
                print(action, row, currentHistoryItem)
                self.dismissCallback()
                tableView.moveRow(at: row, to: 0)
            }
            return [copyAction]
        case .trailing:
            let removeAction = NSTableViewRowAction(style: .destructive, title: "Remove") { (action, row2) in
                print(action, row, currentHistoryItem)
                self.removeItem(currentHistoryItem)
                tableView.removeRows(at: IndexSet(integer: row2), withAnimation: .slideLeft)
            }
            return [removeAction]
        @unknown default:
            fatalError("unknown edge")
        }
    }
}


class ClipDataCell: NSTableCellView {
    
    var label: NSTextField?
    
    init(frame frameRect: NSRect, text title: String) {
        super.init(frame: frameRect)
        label = NSTextField()
        label?.drawsBackground = false
        label?.isBordered = false
        label?.isEditable = false
        label?.usesSingleLineMode = true
        label?.stringValue = title.trimmingCharacters(in: [" "])
    
        self.addSubview(label!)
        
        label?.snp.makeConstraints {make in
            make.edges.equalTo(self).inset(NSEdgeInsetsMake(10, 10, 10, 10))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
