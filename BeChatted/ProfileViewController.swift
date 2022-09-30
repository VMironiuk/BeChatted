//
//  ProfileViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 16.09.2022.
//

import Cocoa

class ProfileViewController: NSViewController {
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var emailLabel: NSTextField!
    @IBOutlet weak var profileAvatarImageView: NSImageView!
    @IBOutlet weak var logoutButton: NSButton!
    
    override var nibName: NSNib.Name? {
        "ProfileView"
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ProfileView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = .white
        view.layer?.cornerRadius = 10
        
        // Buttons
        logoutButton.wantsLayer = true
        logoutButton.layer?.backgroundColor = NSColor(named: "ToolbarColor")?.cgColor
        logoutButton.layer?.cornerRadius = 10
        
        // Labels
        nameLabel.stringValue = AuthService.shared.currentUser.name
        emailLabel.stringValue = AuthService.shared.currentUser.email
        
        // Profile Image
        profileAvatarImageView.image = NSImage(named: AuthService.shared.currentUser.avatarName)
        profileAvatarImageView.wantsLayer = true
        profileAvatarImageView.layer?.borderColor = NSColor.gray.cgColor
        profileAvatarImageView.layer?.borderWidth = 3
        profileAvatarImageView.layer?.cornerRadius = 10
    }
    
    @IBAction func closeButtonAction(_ sender: NSButton) {
        NotificationCenter.default.post(name: Constants.Notification.Name.closeModal, object: nil)
    }
    
    @IBAction func logoutButtonAction(_ sender: NSButton) {
        AuthService.shared.logoutUser()
        NotificationCenter.default.post(name: Constants.Notification.Name.loggedInUserDidChange, object: nil)
        NotificationCenter.default.post(name: Constants.Notification.Name.closeModal, object: nil)
    }
}
