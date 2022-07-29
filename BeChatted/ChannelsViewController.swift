//
//  ChannelsViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 29.07.2022.
//

import Cocoa

class ChannelsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(named: "ChannelsColor")?.cgColor
    }
    
}
