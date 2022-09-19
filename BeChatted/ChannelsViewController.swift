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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoggedInUserDidChange(_:)),
            name: Constants.Notification.Name.loggedInUserDidChange,
            object: nil)
    }
    
    @objc private func onLoggedInUserDidChange(_ notification: Notification) {
        if AuthService.shared.isLoggedIn {
            userNameLabel.stringValue = AuthService.shared.currentUser.name
        } else {
            userNameLabel.stringValue = ""
        }
    }
    
    @IBAction func addChannelAction(_ sender: NSButton) {
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
