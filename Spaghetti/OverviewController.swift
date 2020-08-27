////
////  OverviewController.swift
////  Spaghetti
////
////  Created by Jack Enqvist on 2020-08-24.
////  Copyright © 2020 Jack Enqvist. All rights reserved.
////
//
//import Cocoa
//import SnapKit
//
//class OverviewController: NSTabViewController {
//    
//    var historyPasteItems:[PasteItem]!
//    var pinnedPasteItems:[PasteItem]!
//    
//    var removeItem: ((PasteItem) -> Void)!
//    var dismissCallback: (() -> Void)?
//    var addPinnedItem: ((PasteItem) -> Void)?
//    var removePinnedItem: ((PasteItem) -> Void)?
//    
//    var historyViewController: ViewController!
//    var pinnedViewController: ViewController!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        historyViewController = ViewController()
//        historyViewController.pasteItems = historyPasteItems
//        historyViewController.removeItem = removeItem
//        historyViewController.addPinnedItem = addPinnedItem
//        
//        pinnedViewController = ViewController()
//        pinnedViewController.pasteItems = pinnedPasteItems
//        pinnedViewController.removeItem = removePinnedItem
//        
//        self.addChild(historyViewController)
//        self.addChild(pinnedViewController)
//        
//        tabViewItems[0].label = "History"
//        tabViewItems[1].label = "Pinned"
//        
//        tabView.snp.makeConstraints{ make in
//            make.top.equalTo(view).offset(40)
//            make.leading.trailing.equalTo(view)
//        }
//    }
//    
//    func reloadUI() {
////        historyViewController.tableView.reloadData()
////        pinnedViewController.tableView.reloadData()
//    }
//    
//    override func viewDidAppear() {
//        super.viewDidAppear()
//        tabView.resignFirstResponder()
//    }
//    
//    override func keyUp(with event: NSEvent) {
//        print("event.keyCode", event.keyCode)
//        
//        if event.keyCode == 124 { // right
//            print("tooltip?")
//            tabView.selectTabViewItem(at: 1)
//        }
//        
//        if event.keyCode == 123 { // right
//            print("tooltip?")
//            tabView.selectTabViewItem(at: 0)
//        }
//    }
//    
//    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
//        if let viewController = tabViewItem?.viewController as? ViewController {
//            // TODO update the view more somehow! set the list again? maybe something with didSet???
//            
//            
//            viewController.tableView.reloadData()
//            if viewController.showOnlyPinned {
//                viewController.pasteItems = pinnedPasteItems
//            } else {
//                viewController.pasteItems = historyPasteItems
//            }
//            print("didSelect", viewController.showOnlyPinned)
//        }
//    }
//    
//}
