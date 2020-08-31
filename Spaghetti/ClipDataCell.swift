//
//  ClipDataCell.swift
//  Spaghetti
//
//  Created by Jack Enqvist on 2020-08-27.
//  Copyright © 2020 Jack Enqvist. All rights reserved.
//

import Cocoa

class ClipDataCell: NSTableCellView {
    
    var label: NSTextField = NSTextField()
    
    init(frame frameRect: NSRect, text title: String, pinned isPinned: Bool) {
        super.init(frame: frameRect)
        
        label.drawsBackground = false
        label.isBordered = false
        label.isEditable = false
        label.usesSingleLineMode = true
        label.lineBreakMode = .byTruncatingTail
        label.stringValue = title.trimmingCharacters(in: [" "])
        
        self.addSubview(label)
        
        label.snp.makeConstraints {make in
            make.edges.equalTo(self).inset(NSEdgeInsetsMake(10, 10, 10, 10))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

