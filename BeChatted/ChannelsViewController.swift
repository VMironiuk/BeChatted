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
        userNameLabel.stringValue = ""
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoggedInUserDidChange(_:)),
            name: Constants.Notification.Name.loggedInUserDidChange,
            object: nil)
    }
    
    @objc private func onLoggedInUserDidChange(_ notification: Notification) {
        if AuthService.shared.isLoggedIn {
            userNameLabel.stringValue = AuthService.shared.currentUser.name
            
            MessageService.shared.loadChannels { [weak self] result in
                guard let isSuccess = try? result.get(), isSuccess else { return }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        } else {
            userNameLabel.stringValue = ""
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
        MessageService.shared.channels.count
    }
}

extension ChannelsViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier(rawValue: "ChannelCell")
        let cellView = tableView.makeView(withIdentifier: id, owner: nil) as? ChannelCellView
        cellView?.configure(with: MessageService.shared.channels[row])
        return cellView
    }
}
