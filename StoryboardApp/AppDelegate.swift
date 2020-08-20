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
    
    var popover: NSPopover = NSPopover()
    let hotKey = HotKey(key: .p, modifiers: [.command, .control])
    var history: [String] = [
        "gurka",
        "paprika",
        "1234",
        "Comhem",
        "Tele2",
        "xcode",
        "Swift",
    ]
    var vc : ProgramaticViewController?
    
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
        statusItem.button?.action = #selector(showSettings2)
                
        WatchPasteboard { copied in
            print("copy detected : \(copied)")
            self.history.removeAll { item in
                copied == item
            }
            self.history.append(copied)
        }
            
        hotKey.keyDownHandler = {
            print("hotkey pressed")
            self.showSettings2()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func showSettings2() {
        
        guard let button = statusItem.button else {
            fatalError("could not find the button in the status bar")
        }
       
        let frame = CGRect(origin: .zero, size: CGSize(width: 400, height: 300))
        let popover = NSPopover()

        vc = ProgramaticViewController()
        vc?.history = history
        vc?.removeItem = { (str: String) in
            print("removing from closure")
            self.history.removeAll { $0 == str }
        }
        vc?.dismissCallback = {
            print("closing from closure!")
            popover.close()
        }
        vc!.view.frame = frame
        
        popover.contentViewController = vc
        popover.behavior = .transient
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
    }
    
    @objc func showSettings() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("could not find the viewcontroller")
        }
        
        //self.vc = vc
        
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

