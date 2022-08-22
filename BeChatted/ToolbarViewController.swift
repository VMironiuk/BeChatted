//
//  ToolbarViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 29.07.2022.
//

import Cocoa

enum ModalType {
    case login
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
    }
    
    @objc private func onShowModalNotification(_ notification: Notification) {
        guard modalBackgroundView == .none else { return }
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
        
        guard let modalType = notification.userInfo?[Constants.UserInfoKey.modalType] as? ModalType else {
            fatalError("Undefined modal type")
        }
        switch modalType {
        case .login:
            let loginViewController = LoginViewController(nibName: nil, bundle: nil)
            let loginView = loginViewController.view
            modalBackgroundView.addSubview(loginView)
            self.addChild(loginViewController)
            loginView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loginView.widthAnchor.constraint(equalToConstant: 500),
                loginView.heightAnchor.constraint(equalToConstant: 375),
                loginView.centerXAnchor.constraint(equalTo: modalBackgroundView.centerXAnchor),
                loginView.centerYAnchor.constraint(equalTo: modalBackgroundView.centerYAnchor),
            ])
        }
    }
    
    @objc private func stackViewDidPressAction() {
        let userInfo: [AnyHashable : Any] = [Constants.UserInfoKey.modalType : ModalType.login]
        
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
    
}
