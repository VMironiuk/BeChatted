//
//  LoginViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 16.08.2022.
//

import Cocoa

class LoginViewController: NSViewController {
    
    @IBOutlet private weak var emailTextField: NSTextField!
    @IBOutlet private weak var passwordTextField: NSSecureTextField!
    @IBOutlet private weak var loginButton: NSButton!
    
    override var nibName: NSNib.Name? {
        "LoginView"
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "LoginView", bundle: nibBundleOrNil)
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
        let userNamePlaceholderAttributedString = NSAttributedString(string: "Email", attributes: attributes)
        emailTextField.placeholderAttributedString = userNamePlaceholderAttributedString
        let passwordPlaceholderAttributedString = NSAttributedString(string: "Password", attributes: attributes)
        passwordTextField.placeholderAttributedString = passwordPlaceholderAttributedString
        
        // Buttons
        loginButton.wantsLayer = true
        loginButton.layer?.backgroundColor = NSColor(named: "ToolbarColor")?.cgColor
        loginButton.layer?.cornerRadius = 10
    }
    
    @IBAction func closeButtonAction(_ sender: NSButton) {
        NotificationCenter.default.post(name: Constants.Notification.Name.closeModal, object: nil)
    }
    
    @IBAction func createAccountButtonAction(_ sender: NSButton) {
        let userInfo: [AnyHashable : Any] = [Constants.UserInfoKey.modalType : ModalType.createAccount]
        
        NotificationCenter.default.post(
            name: Constants.Notification.Name.showModal,
            object: nil,
            userInfo: userInfo)
    }
    
    @IBAction func loginButtonAction(_ sender: NSButton) {
        AuthService.shared.findUser(byEmail: emailTextField.stringValue) { result in
            guard let isSuccess = try? result.get(), isSuccess else { return }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Constants.Notification.Name.closeModal, object: nil)
                NotificationCenter.default.post(name: Constants.Notification.Name.loggedInUserDidChange, object: nil)
            }
        }
    }
}
