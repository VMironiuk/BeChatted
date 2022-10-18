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
    private var messages: [Message] = []
    private var isTyping: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(named: "ChatColor")?.cgColor
        
        tableView.dataSource = self
        tableView.delegate = self
        messageTextField.delegate = self
        
        messageContainerView.wantsLayer = true
        messageContainerView.layer?.borderWidth = 1
        messageContainerView.layer?.borderColor = NSColor(named: "ChannelColor")?.cgColor
        messageContainerView.layer?.cornerRadius = 5
        
        channelNameLabel.stringValue = "Please log in"
        channelDescriptionLabel.stringValue = ""
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onChannelDidChange(_:)),
            name: Constants.Notification.Name.channelDidChange,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoggedInUserDidChange(_:)),
            name: Constants.Notification.Name.loggedInUserDidChange,
            object: nil)
                
        WebSocketService.shared.fetchMessage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                guard message.channelId == self.channel?.id, AuthService.shared.isLoggedIn else { return }
                print("Send/Fetch message successfully!")
                self.messages.append(message)
                self.tableView.reloadData()
                self.tableView.scrollRowToVisible(self.messages.count - 1)
            case .failure(let error):
                print("Send/Fetch message error: \(error)")
            }
        }
        
        WebSocketService.shared.fetchTypingUsers { [weak self] result in
            guard let usersTyping = try? result.get() else { return }
            self?.handleUsersTyping(usersTyping)
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let window = messageTextField.window, let fieldEditor = window.fieldEditor(true, for: messageTextField) as? NSTextView {
            fieldEditor.insertionPointColor = .unemphasizedSelectedTextBackgroundColor
        }
    }
    
    private func handleUsersTyping(_ usersTyping: [String: String]) {
        var names: String = ""
        var usersTypingCount: Int = .zero
        for (userName, channelId) in usersTyping {
            guard channelId == channel?.id, userName != AuthService.shared.currentUser.name else { continue }
            names = names.isEmpty ? userName : "\(names), \(userName)"
            usersTypingCount += 1
        }
        
        guard !names.isEmpty else { return { userTypingLabel.stringValue = "" }() }
        let verb = usersTypingCount == 1 ? "is" : "are"
        let finalText = "\(names) \(verb) typing..."
        userTypingLabel.stringValue = finalText
    }
    
    @objc private func onChannelDidChange(_ notification: Notification) {
        guard let channel = notification.userInfo?[Constants.UserInfoKey.channel] as? Channel else { return }
        self.channel = channel
        channelNameLabel.stringValue = channel.name
        channelDescriptionLabel.stringValue = channel.description
        messages.removeAll()
        
        MessageService.shared.loadMessages(by: channel.id) { [weak self] result in
            guard let self = self, let isSuccess = try? result.get(), isSuccess else { return }
            self.messages = MessageService.shared.messages
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.scrollRowToVisible(self.messages.count - 1)
            }
        }
    }
    
    @objc private func onLoggedInUserDidChange(_ notification: Notification) {
        if !AuthService.shared.isLoggedIn {
            channelNameLabel.stringValue = "Please log in"
            channelDescriptionLabel.stringValue = ""
            
            messages.removeAll()
            tableView.reloadData()
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
        
        
        WebSocketService.shared.emitStopTyping(userName: AuthService.shared.currentUser.name)
        messageTextField.stringValue = ""
    }
}

extension ChatViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        messages.count
    }
}

extension ChatViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier(rawValue: "MessageCell")
        let cell = tableView.makeView(withIdentifier: id, owner: nil) as? MessageCell
        let message = messages[row]
        cell?.configure(with: message)
        return cell
    }
}

extension ChatViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if messageTextField.stringValue == "" {
            isTyping = false
            WebSocketService.shared.emitStopTyping(userName: AuthService.shared.currentUser.name)
        }
        else {
            guard !isTyping, let channel = channel else { return }
            isTyping = true
            WebSocketService.shared.emitStartTyping(userName: AuthService.shared.currentUser.name, channelId: channel.id)
        }
    }
}
