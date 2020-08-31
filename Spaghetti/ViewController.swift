//
//  ProgramaticViewController.swift
//  StoryboardApp
//
//  Created by Jack Enqvist on 2020-08-06.
//  Copyright © 2020 Jack Enqvist. All rights reserved.
//

import Cocoa
import SnapKit
import Sauce


class ViewController: NSViewController {
    
    let pasteService: PasteService = PasteService()
    
    var label: NSTextField!
    let scrollView = NSScrollView()
    let tableView = NSTableView()
    var settingsBuitton: NSPopUpButton = NSPopUpButton(frame: .zero, pullsDown: true)
    var dataModel: PasteBoardModel! {
        didSet {
            updateUI()
        }
    }
    var dismissCallback: (() -> Void)?
    var showPinnedItems = false
    
    var reversedHistory: [PasteItem] {
        if showPinnedItems {
            return dataModel.pasteItems.filter { $0.isPinned }.reversed()
        } else {
            return dataModel.pasteItems.filter { !$0.isPinned }.reversed()
        }
    }
    
    override var acceptsFirstResponder: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup key listening without the BEEEP sound ...
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.keyDownPressed(with: $0) {
                return nil
            }
            return $0
        }
        
        setupTableView()
        setupMenu()
        setupLabel()
        
        calculateConstraints()
        // dont highlight the settings button
        settingsBuitton.refusesFirstResponder = true
    }
    
    func calculateConstraints() {
        label.snp.makeConstraints { make -> Void in
            make.centerX.top.equalTo(view).inset(NSEdgeInsetsMake(10, 10, 10, 10))
            
        }
        settingsBuitton.snp.makeConstraints { make -> Void in
            make.trailing.top.equalTo(view).inset(NSEdgeInsetsMake(10, 10, 10, 10))
        }
        
        tableView.snp.makeConstraints { make -> Void in
            make.trailing.leading.top.equalTo(scrollView).inset(NSEdgeInsetsMake(5, 5, 5, 5))
        }
        
        scrollView.snp.makeConstraints { make -> Void in
            make.top.equalTo(settingsBuitton.snp.bottom).offset(10)
            make.bottom.leading.trailing.equalTo(view)
        }
    }
    
    func setupLabel() {
        label = NSTextField(string: showPinnedItems ? "Saved" : "History")
        label.refusesFirstResponder = true
        label.isEditable = false
        label.drawsBackground = false
        label.isBordered = false
        
        view.addSubview(label)
    }
    
    func setupTableView() {
        
        scrollView.documentView = tableView
        
        scrollView.drawsBackground = false
        view.addSubview(scrollView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.target = self
        tableView.doubleAction = #selector(handleDoubleClick)
        
        let dataCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "DataColumn"))
        tableView.addTableColumn(dataCol)
        
        tableView.frame = scrollView.bounds
        
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = false
        
        tableView.headerView = nil
        scrollView.documentView = tableView
        
        //        view.addSubview(tableView)
    }
    
    @objc func handleDoubleClick() {
        if tableView.selectedRow >= 0 {
            actuallyPaste()
        }
    }
    
    func setupMenu() {
        settingsBuitton = NSPopUpButton(frame: .zero, pullsDown: true)
        settingsBuitton.addItem(withTitle: MenuChoices.EXIT.rawValue)
        settingsBuitton.addItem(withTitle: MenuChoices.CLEAR.rawValue)
        settingsBuitton.addItem(withTitle: MenuChoices.HELP.rawValue)
        
        let settingsItem = NSMenuItem()
        
        settingsBuitton.menu?.insertItem(settingsItem, at: 0)
        settingsBuitton.action = #selector(onMenuClick)
        
        
        settingsItem.image = NSImage(named: NSImage.Name.ACTION)
        let cell = settingsBuitton.cell as? NSButtonCell
        cell?.imagePosition = .imageOnly
        cell?.bezelStyle = .texturedRounded
        
        view.addSubview(settingsBuitton)
    }
    
    
    override func loadView() {
        self.view = NSView()
    }
    
    func keyDownPressed(with event: NSEvent) -> Bool {
        print("caught a key down: \(event.keyCode)")
        if event.keyCode == 36 { // Enter Key
            actuallyPaste()
            return true
        }
        
        if event.keyCode == 124 { // right
            print("showPinnedItems -> true")
            showPinnedItems = !showPinnedItems
            updateUI()
            return true
        }
        
        if event.keyCode == 123 { // right
            print("showPinnedItems -> false")
            showPinnedItems = !showPinnedItems
            updateUI()
            return true
        }
        
        return false
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        print("updateUI - ", self.showPinnedItems)
        if label != nil {
            self.label.stringValue = self.showPinnedItems ? "Saved" : "History"
            self.tableView.reloadData()
//            removeConstraints()
//            calculateConstraints()
        }
    }
    
    func removeConstraints() {
        label.snp.removeConstraints()
        settingsBuitton.snp.removeConstraints()
        tableView.snp.removeConstraints()
    }
    
    @objc func onMenuClick() {
        if let command = settingsBuitton.selectedItem?.title {
            switch command {
            case MenuChoices.EXIT.rawValue:
                print("Exit")
                NSApplication.shared.terminate(self)
            case MenuChoices.CLEAR.rawValue:
                print("Clear")
                dataModel.clear()
                tableView.reloadData()
            case MenuChoices.HELP.rawValue:
                let alert = NSAlert()
                alert.messageText = "USAGE"
                alert.informativeText = """
                ° Use CMD + CTRL + P to open
                
                ° Use the ↑ and ↓ keys to navigate
                
                ° Use the enter ⮐ key to paste a selected item.
                
                ° Use swipe(scroll) from the left to save an item,
                    and right to remove an item.
                
                ° Use the ← and → to navigate between saved items and History
                """
                alert.addButton(withTitle: "OK")
                alert.alertStyle = .informational
                alert.runModal()
                print("help")
            default:
                print("Default: no actionmatching command: ", command)
            }
        }
    }
    
    @objc func actuallyPaste() {
        let currentSelectionIndex = max(self.tableView.selectedRow, 0)
        let currentSelection = self.reversedHistory[currentSelectionIndex % reversedHistory.count]
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(currentSelection.value, forType: .string)
        
        pasteService.paste()
        
        tableView.moveRow(at: self.tableView.selectedRow, to: 0)
        
        if let dissmiss = self.dismissCallback {
            showPinnedItems = false
            dissmiss()
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        print("numberOfRows", reversedHistory.count)
        return reversedHistory.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = reversedHistory[row]
        let height: CGFloat = 35.0
        tableView.rowHeight = height
        
        let frameRect = NSRect(x: 0, y: 0, width: tableColumn!.width, height: height)
        let tableCellView = ClipDataCell(frame: frameRect, text:  item.value, pinned: item.isPinned )
        
        return tableCellView
    }
    
    // MARK: NSTableViewDelegate - swipe actions
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        let item : PasteItem = reversedHistory[row]
        
        let removeAction = NSTableViewRowAction(style: .destructive, title: "Remove") { (action, row) in
            self.dataModel.remove(item)
            tableView.removeRows(at: IndexSet(integer: row), withAnimation: .slideLeft)
        }
        
        let pinAction = NSTableViewRowAction(style: .regular, title: "Save") { (action, row) in
            self.dataModel.addToPinned(item)
            tableView.removeRows(at: IndexSet(integer: row), withAnimation: .slideRight)
            
        }
        
        let removePinAction = NSTableViewRowAction(style: .destructive, title: "Remove") { (action, row) in
            self.dataModel.removePinned(item)
            tableView.removeRows(at: IndexSet(integer: row), withAnimation: .slideRight)
        }
        
        switch edge {
        case .leading:
            if self.showPinnedItems {
                return [removePinAction]
            } else {
                return [pinAction]
            }
        case .trailing:
            return [removeAction]
        @unknown default:
            fatalError("unknown edge")
        }
    }
}
