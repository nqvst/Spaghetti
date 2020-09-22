//
//  AppDelegate.swift
//  StoryboardApp
//
//  Created by Jack Enqvist on 2020-06-25.
//  Copyright © 2020 Jack Enqvist. All rights reserved.
//

import Cocoa
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    let openHotKey = HotKey(key: .p, modifiers: [.command, .control])
    
    var accessibilityService: AccessibilityService = AccessibilityService()
    var dataModel = PasteBoardModel([])
    var viewController: ViewController?
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 𝒞 originale
        statusItem.button?.title = "𝒞"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(showPopover)
                
        WatchPasteboard { copied in
            print("copy detected : \(copied)")
            self.dataModel.add(PasteItem(copied))
        }
            
        openHotKey.keyDownHandler = {
            print("hotkey pressed")
            self.showPopover()
        }
        
        dataModel.loadItems()
        
        accessibilityService.isAccessibilityEnabled(isPrompt: true)
        
    }
    
    @objc func showPopover() {
        
        guard let button = statusItem.button else {
            fatalError("could not find the button in the status bar")
        }
       
        let frame = CGRect(origin: .zero, size: CGSize(width: 400, height: 300))
        let popover = NSPopover()

        if viewController == nil {
            viewController = ViewController()
        }
        
        viewController?.dataModel = self.dataModel
        viewController?.showPinnedItems = false

        
        viewController?.dismissCallback = {
            print("closing from closure!")
            popover.close()
        }
        
        viewController!.view.frame = frame
        
        popover.contentViewController = viewController
        popover.behavior = .transient
        popover.contentSize = CGSize(width: 400, height: 300)
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        dataModel.saveItems()
    }
}

