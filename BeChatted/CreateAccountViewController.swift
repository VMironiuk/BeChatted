//
//  CreateAccountViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.08.2022.
//

import Cocoa

class CreateAccountViewController: NSViewController {
    
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
    }

    @IBAction func closeButtonAction(_ sender: NSButton) {
        NotificationCenter.default.post(name: Constants.Notification.Name.closeModal, object: nil)
    }
}
