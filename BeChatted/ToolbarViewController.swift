//
//  ToolbarViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 29.07.2022.
//

import Cocoa

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
    }
    
    @objc private func onShowModalNotification(_ notification: Notification) {
        guard modalBackgroundView == .none else { return }
        modalBackgroundView = InteractionLockView()
        modalBackgroundView.wantsLayer = true
        modalBackgroundView.layer?.backgroundColor = .black
        modalBackgroundView.alphaValue = 0.75
        modalBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modalBackgroundView)
        NSLayoutConstraint.activate([
            modalBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            modalBackgroundView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    @objc private func stackViewDidPressAction() {
        NotificationCenter.default.post(
            name: Constants.Notification.Name.showModal,
            object: nil,
            userInfo: nil)
    }
    
}
