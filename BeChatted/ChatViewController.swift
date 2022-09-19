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
    @IBOutlet private weak var messageContainerView: NSView!
    @IBOutlet private weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(named: "ChatColor")?.cgColor
        
        messageContainerView.wantsLayer = true
        messageContainerView.layer?.borderWidth = 1
        messageContainerView.layer?.borderColor = NSColor(named: "ChannelColor")?.cgColor
        messageContainerView.layer?.cornerRadius = 5
        
        if AuthService.shared.isLoggedIn {
            channelNameLabel.stringValue = "#general"
            channelDescriptionLabel.stringValue = "Let's talk about general topics "
        } else {
            channelNameLabel.stringValue = ""
            channelDescriptionLabel.stringValue = ""
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let window = messageTextField.window, let fieldEditor = window.fieldEditor(true, for: messageTextField) as? NSTextView {
            fieldEditor.insertionPointColor = .unemphasizedSelectedTextBackgroundColor
        }
    }
    
    @IBAction func sendMessageAction(_ sender: NSButton) {
        print(#function)
    }
    
}
