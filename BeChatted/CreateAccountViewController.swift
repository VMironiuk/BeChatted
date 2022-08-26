//
//  CreateAccountViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.08.2022.
//

import Cocoa

class CreateAccountViewController: NSViewController {
    
    @IBOutlet private weak var nameTextField: NSTextField!
    @IBOutlet private weak var emailTextField: NSTextField!
    @IBOutlet private weak var passwordTextField: NSSecureTextField!
    @IBOutlet private weak var createAccountButton: NSButton!
    @IBOutlet private weak var chooseAvatarButton: NSButton!
    @IBOutlet private weak var profileAvatarImageView: NSImageView!
    
    override var nibName: NSNib.Name? {
        "CreateAccountView"
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "CreateAccountView", bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = .white
        view.layer?.cornerRadius = 10
        
        // Text fields
        let attributes = [
            NSAttributedString.Key.foregroundColor : NSColor.lightGray,
            NSAttributedString.Key.font : NSFont.systemFont(ofSize: 13)
        ]
        let namePlaceholderAttributedString = NSAttributedString(string: "Name", attributes: attributes)
        nameTextField.placeholderAttributedString = namePlaceholderAttributedString
        let emailPlaceholderAttributedString = NSAttributedString(string: "Email", attributes: attributes)
        emailTextField.placeholderAttributedString = emailPlaceholderAttributedString
        let passwordPlaceholderAttributedString = NSAttributedString(string: "Password", attributes: attributes)
        passwordTextField.placeholderAttributedString = passwordPlaceholderAttributedString
        
        // Buttons
        createAccountButton.wantsLayer = true
        createAccountButton.layer?.backgroundColor = NSColor(named: "ToolbarColor")?.cgColor
        createAccountButton.layer?.cornerRadius = 10
        
        chooseAvatarButton.wantsLayer = true
        chooseAvatarButton.layer?.backgroundColor = NSColor(named: "ToolbarColor")?.cgColor
        chooseAvatarButton.layer?.cornerRadius = 10
        
        // Image views
        profileAvatarImageView.wantsLayer = true
        profileAvatarImageView.layer?.borderColor = NSColor.gray.cgColor
        profileAvatarImageView.layer?.borderWidth = 3
        profileAvatarImageView.layer?.cornerRadius = 10
    }

    @IBAction func closeButtonAction(_ sender: NSButton) {
        NotificationCenter.default.post(name: Constants.Notification.Name.closeModal, object: nil)
    }
}
