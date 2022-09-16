//
//  ToolbarViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 29.07.2022.
//

import Cocoa

enum ModalType {
    case login
    case createAccount
    case profile
}

class ToolbarViewController: NSViewController {

    @IBOutlet private weak var loginImageView: NSImageView!
    @IBOutlet private weak var loginLabel: NSTextField!
    @IBOutlet private weak var stackView: NSStackView!
    
    private var modalBackgroundView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(named: "ToolbarColor")?.cgColor
        
        stackView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(stackViewDidPressAction)))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onShowModalNotification(_:)),
            name: Constants.Notification.Name.showModal,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onCloseModalBackgroundViewNotification(_:)),
            name: Constants.Notification.Name.closeModal,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoggedInUserDidChange(_:)),
            name: Constants.Notification.Name.loggedInUserDidChange,
            object: nil)
    }
    
    @objc private func onShowModalNotification(_ notification: Notification) {
        if modalBackgroundView == .none {
            modalBackgroundView = InteractionLockView()
            modalBackgroundView.wantsLayer = true
            modalBackgroundView.layer?.backgroundColor = .black
            modalBackgroundView.alphaValue = 0.0
            modalBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(modalBackgroundView)
            NSLayoutConstraint.activate([
                modalBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                modalBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                modalBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                modalBackgroundView.topAnchor.constraint(equalTo: view.topAnchor)
            ])
            
            NSAnimationContext.runAnimationGroup { [weak self] context in
                context.duration = 0.3
                self?.modalBackgroundView.animator().alphaValue = 0.75
                self?.view.layoutSubtreeIfNeeded()
            }
        }
        
        guard let modalType = notification.userInfo?[Constants.UserInfoKey.modalType] as? ModalType else {
            fatalError("Undefined modal type")
        }
        
        modalBackgroundView.subviews.forEach { $0.removeFromSuperview() }
        modalBackgroundView.subviews = []
        
        let viewController: NSViewController
        switch modalType {
        case .login:
            viewController = LoginViewController(nibName: nil, bundle: nil)
        case .createAccount:
            viewController = CreateAccountViewController(nibName: nil, bundle: nil)
        case .profile:
            viewController = ProfileViewController(nibName: nil, bundle: nil)
        }
        
        let childView = viewController.view
        modalBackgroundView.addSubview(childView)
        self.addChild(viewController)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.widthAnchor.constraint(equalToConstant: 400),
            childView.heightAnchor.constraint(equalToConstant: 275),
            childView.centerXAnchor.constraint(equalTo: modalBackgroundView.centerXAnchor),
            childView.centerYAnchor.constraint(equalTo: modalBackgroundView.centerYAnchor),
        ])
    }
    
    @objc private func stackViewDidPressAction() {
        var userInfo: [AnyHashable : Any] = [:]
        
        if AuthService.shared.isLoggedIn {
            userInfo = [Constants.UserInfoKey.modalType : ModalType.profile]
        } else {
            userInfo = [Constants.UserInfoKey.modalType : ModalType.login]
        }
        
        NotificationCenter.default.post(
            name: Constants.Notification.Name.showModal,
            object: nil,
            userInfo: userInfo)
    }
    
    @objc private func onCloseModalBackgroundViewNotification(_ notification: Notification) {
        guard modalBackgroundView != .none else { return }
        NSAnimationContext.runAnimationGroup { [weak self] context in
            context.duration = 0.3
            self?.modalBackgroundView.animator().alphaValue = 0.0
            self?.view.layoutSubtreeIfNeeded()
        } completionHandler: { [weak self] in
            guard let self = self else { return }
            self.modalBackgroundView.removeFromSuperview()
            self.modalBackgroundView = nil
            self.removeChild(at: self.children.count - 1)
        }
    }
    
    @objc private func onLoggedInUserDidChange(_ notification: Notification) {
        if AuthService.shared.isLoggedIn {
            loginLabel.stringValue = AuthService.shared.currentUser.name
            loginImageView.image = NSImage(named: AuthService.shared.currentUser.avatarName)
            loginImageView.wantsLayer = true
            loginImageView.layer?.cornerRadius = 5
            loginImageView.layer?.borderWidth = 1
            loginImageView.layer?.borderColor = NSColor.secondaryLabelColor.cgColor
            // TODO: set avatar color
        } else {
            loginLabel.stringValue = "Login"
            loginImageView.image = NSImage(named: "profileDefault")
        }
    }
}
