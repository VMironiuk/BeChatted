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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(named: "ToolbarColor")?.cgColor
        
        stackView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(loginAction)))
    }
    
    @objc private func loginAction() {
        print(#function)
    }
    
}
