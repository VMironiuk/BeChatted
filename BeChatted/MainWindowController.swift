//
//  MainWindowController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 29.07.2022.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        let toolbar = NSToolbar()
        toolbar.showsBaselineSeparator = false
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.minSize = NSSize(width: 950, height: 600)
        window?.toolbar = toolbar
        window?.backgroundColor = NSColor(named: "ToolbarColor")
    }

}
