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
    
    private var channel: Channel?
    
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
        self.channel = channel
        channelNameLabel.stringValue = channel.name
        channelDescriptionLabel.stringValue = channel.description
        
        MessageService.shared.loadMessages(by: channel.id) { result in
            guard let isSuccess = try? result.get(), isSuccess else { return }
            MessageService.shared.messages.forEach { print($0.messageBody) }
            print("Messages: \(MessageService.shared.messages)")
        }
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

        let message = AddMessage(
            messageBody: messageTextField.stringValue,
            userId: AuthService.shared.currentUser.id,
            channelId: channel?.id ?? "",
            userName: AuthService.shared.currentUser.name,
            userAvatar: AuthService.shared.currentUser.avatarName,
            userAvatarColor: "avatarColor")
        
        MessageService.shared.sendMessage(message) { result in
            switch result {
            case .success:
                print("Message sent successfully")
            case .failure:
                print("Message send failed")
            }
        }
        
        messageTextField.stringValue = ""
    }
}
