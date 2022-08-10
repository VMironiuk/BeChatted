//
//  ChannelsViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 29.07.2022.
//

import Cocoa

class ChannelsViewController: NSViewController {

    @IBOutlet private weak var userNameLabel: NSTextField!
    @IBOutlet private weak var channelsLabel: NSTextField!
    @IBOutlet private weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(named: "ChannelsColor")?.cgColor
    }
    
    @IBAction func addChannelAction(_ sender: NSButton) {
        print(#function)
    }
    
}
