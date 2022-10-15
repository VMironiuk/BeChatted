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
    
    private var selectedRow: Int = .zero
    private var channels: [Channel] = []
    private var unreadChannelIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(named: "ChannelsColor")?.cgColor
        userNameLabel.stringValue = ""
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoggedInUserDidChange(_:)),
            name: Constants.Notification.Name.loggedInUserDidChange,
            object: nil)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        WebSocketService.shared.fetchChannel { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let channel):
                guard AuthService.shared.isLoggedIn else { return }
                print("Add/Fetch channel successfully!")
                self.channels.append(channel)
                self.tableView.reloadData()
                self.tableView.scrollRowToVisible(self.channels.count - 1)
            case .failure(let error):
                print("Send/Fetch message error: \(error)")
            }
        }
        
        WebSocketService.shared.fetchMessage { [weak self] result in
            guard AuthService.shared.isLoggedIn,
                  let self = self,
                  let message = try? result.get(),
                  message.channelId != self.channels[self.selectedRow].id else { return }
            
            self.unreadChannelIds.append(message.channelId)
            self.tableView.reloadData()
        }
    }
    
    private func sendFirstChannelIfNeeded() {
        guard let channel = MessageService.shared.channels.first else { return }
        
        let userInfo = [Constants.UserInfoKey.channel: channel]
        NotificationCenter.default.post(
            name: Constants.Notification.Name.channelDidChange,
            object: nil,
            userInfo: userInfo)
    }
    
    @objc private func onLoggedInUserDidChange(_ notification: Notification) {
        if AuthService.shared.isLoggedIn {
            userNameLabel.stringValue = AuthService.shared.currentUser.name
            
            MessageService.shared.loadChannels { [weak self] result in
                guard let isSuccess = try? result.get(), isSuccess else { return }
                DispatchQueue.main.async {
                    self?.channels = MessageService.shared.channels
                    self?.tableView.reloadData()
                    self?.sendFirstChannelIfNeeded()
                }
            }
        } else {
            userNameLabel.stringValue = ""
            
            channels.removeAll()
            tableView.reloadData()
        }
    }
    
    @IBAction func addChannelAction(_ sender: NSButton) {
        var userInfo: [AnyHashable : Any] = [:]
        
        if AuthService.shared.isLoggedIn {
            userInfo = [Constants.UserInfoKey.modalType : ModalType.addChannel]
        } else {
            userInfo = [Constants.UserInfoKey.modalType : ModalType.login]
        }
        
        NotificationCenter.default.post(
            name: Constants.Notification.Name.showModal,
            object: nil,
            userInfo: userInfo)
    }
}

extension ChannelsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        channels.count
    }
}

extension ChannelsViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier(rawValue: "ChannelCell")
        let cellView = tableView.makeView(withIdentifier: id, owner: nil) as? ChannelCellView
        let isSelected = selectedRow == row
        let channel = channels[row]
        let isUnread = unreadChannelIds.contains(channel.id)
        cellView?.configure(with: channel, isSelected: isSelected, isUnread: isUnread)
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        selectedRow = tableView.selectedRow
        unreadChannelIds = unreadChannelIds.filter { $0 != channels[selectedRow].id }
        tableView.reloadData()
        
        let channel = channels[selectedRow]
        let userInfo = [Constants.UserInfoKey.channel: channel]
        NotificationCenter.default.post(
            name: Constants.Notification.Name.channelDidChange,
            object: nil,
            userInfo: userInfo)
    }
}
