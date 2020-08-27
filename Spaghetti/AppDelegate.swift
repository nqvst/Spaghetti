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
    let hotKey = HotKey(key: .p, modifiers: [.command, .control])
    var accessibilityService: AccessibilityService = AccessibilityService()
    var dataModel = PasteBoardModel([])
    
    let maxNumerOfItems = 20
    var viewController: ViewController?
    
    var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func WatchPasteboard(copied: @escaping (_ copiedString:String) -> Void) {
        let pasteboard = NSPasteboard.general
        var changeCount = NSPasteboard.general.changeCount
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let copiedString = pasteboard.string(forType: .string) {
                if pasteboard.changeCount != changeCount {
                    copied(copiedString)
                    changeCount = pasteboard.changeCount
                }
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "𝒞"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(showPopover)
                
        WatchPasteboard { copied in
            print("copy detected : \(copied)")
            self.dataModel.add(PasteItem(copied))
            
        }
            
        hotKey.keyDownHandler = {
            print("hotkey pressed")
            self.showPopover()
        }
        
        //accessibilityService.isAccessibilityEnabled(isPrompt: true)
    }
    
    
    
    func saveToDisk() {
        //let documentsUrl = FileManager.default.urls(for: .userDirectory, in: .userDomainMask)[0] as NSURL
        // add a filename
        //let fileUrl = documentsUrl.appendingPathComponent(".foo.txt")
        //
//        try! history
//                .map({$0.value})
//                .joined(separator: "\n")
//                .write(to: fileUrl!, atomically: true, encoding: String.Encoding.utf8)
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
        
        //reset the view before opening the popup again
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

}

