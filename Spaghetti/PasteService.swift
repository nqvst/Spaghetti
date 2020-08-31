//
//  PasteService.swift
//  Spaghetti
//
//  Created by Jack Enqvist on 2020-08-29.
//  Copyright © 2020 Jack Enqvist. All rights reserved.
//

import Foundation
import Sauce

class PasteService {
    func paste () {
        let vKeyCode = Sauce.shared.keyCode(by: .v)
        print("vKeyCode", vKeyCode)
        DispatchQueue.main.async {
            let source = CGEventSource(stateID: .combinedSessionState)
            // Disable local keyboard events while pasting
            source?.setLocalEventsFilterDuringSuppressionState([.permitLocalMouseEvents, .permitSystemDefinedEvents], state: .eventSuppressionStateSuppressionInterval)
            // Press Command + V
            let keyVDown = CGEvent(keyboardEventSource: source, virtualKey: vKeyCode, keyDown: true)
            keyVDown?.flags = .maskCommand
            // Release Command + V
            let keyVUp = CGEvent(keyboardEventSource: source, virtualKey: vKeyCode, keyDown: false)
            keyVUp?.flags = .maskCommand
            // Post Paste Command
            keyVDown?.post(tap: .cgAnnotatedSessionEventTap)
            keyVUp?.post(tap: .cgAnnotatedSessionEventTap)
        }
    }
}
