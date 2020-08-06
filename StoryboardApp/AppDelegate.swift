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
    var history: [String] = ["gurka", "sparris", "1238798394"]
    var vc : ViewController?
    
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
        statusItem.button?.action = #selector(showSettings)
                
        WatchPasteboard { copied in
            print("copy detected : \(copied)")
            self.history.removeAll { item in
                copied == item
            }
            self.history.append(copied)
        }
            
        hotKey.keyDownHandler = {
            print("hotkey pressed")
            self.showSettings()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func justShutIt() {
        print("nothing")
    }
    
    @objc func showSettings() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("could not find the viewcontroller")
        }
        
        self.vc = vc
        
        guard let button = statusItem.button else {
            fatalError("could not find the button in the status bar")
        }
        
        vc.addHistory(history: history)
        
        let popover = NSPopover()
        popover.contentViewController = vc
        popover.behavior = .transient
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
    }
}

