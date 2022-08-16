//
//  LoginViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 16.08.2022.
//

import Cocoa

class LoginViewController: NSViewController {
    
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
    }
    
}
