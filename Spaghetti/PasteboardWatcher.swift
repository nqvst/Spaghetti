//
//  PasteboardWatcher.swift
//  Spaghetti
//
//  Created by Jack Enqvist on 2020-09-03.
//  Copyright © 2020 Jack Enqvist. All rights reserved.
//

import Foundation
import Cocoa

func WatchPasteboard(copied: @escaping (_ copiedString:String) -> Void) {
    let pasteboard = NSPasteboard.general
    var changeCount = NSPasteboard.general.changeCount
    
    Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { _ in
        if let copiedString = pasteboard.string(forType: .string) {
            if pasteboard.changeCount != changeCount {
                copied(copiedString)
                changeCount = pasteboard.changeCount
            }
        }
    }
}
