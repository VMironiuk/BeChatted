//
//  ChatViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 29.07.2022.
//

import Cocoa

class ChatViewController: NSViewController {

    @IBOutlet private weak var channelNameLabel: NSTextField!
    @IBOutlet private weak var channelDescriptionLabel: NSTextField!
    @IBOutlet private weak var userTypingLabel: NSTextField!
    @IBOutlet private weak var messageTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(named: "ChatColor")?.cgColor
    }
    
    @IBAction func sendMessageAction(_ sender: NSButton) {
        print(#function)
    }
    
}
