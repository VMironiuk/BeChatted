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
        
        channelNameLabel.stringValue = ""
        channelDescriptionLabel.stringValue = ""
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onChannelDidChange(_:)),
            name: Constants.Notification.Name.channelDidChange,
            object: nil)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let window = messageTextField.window, let fieldEditor = window.fieldEditor(true, for: messageTextField) as? NSTextView {
            fieldEditor.insertionPointColor = .unemphasizedSelectedTextBackgroundColor
        }
    }
    
    @objc private func onChannelDidChange(_ notification: Notification) {
        guard let channel = notification.userInfo?[Constants.UserInfoKey.channel] as? Channel else { return }
        channelNameLabel.stringValue = channel.name
        channelDescriptionLabel.stringValue = channel.description
    }
    
    @IBAction func sendMessageAction(_ sender: NSButton) {
        guard AuthService.shared.isLoggedIn else {
            let userInfo: [AnyHashable : Any] = [Constants.UserInfoKey.modalType : ModalType.login]
            
            NotificationCenter.default.post(
                name: Constants.Notification.Name.showModal,
                object: nil,
                userInfo: userInfo)

            return
        }
    }
    
}
