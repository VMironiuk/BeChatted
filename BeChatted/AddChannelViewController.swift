//
//  AddChannelViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 24.09.2022.
//

import Cocoa

class AddChannelViewController: NSViewController {
    
    @IBOutlet private weak var channelNameTextField: NSTextField!
    @IBOutlet private weak var channelDescriptionTextField: NSTextField!
    @IBOutlet private weak var createChannelButton: NSButton!
    
    override var nibName: NSNib.Name? {
        "AddChannelView"
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "AddChannelView", bundle: nil)
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
        let channelNamePlaceholderAttributedString = NSAttributedString(string: "Channel Name", attributes: attributes)
        channelNameTextField.placeholderAttributedString = channelNamePlaceholderAttributedString
        let channelDescriptionPlaceholderAttributedString = NSAttributedString(string: "Channel Description", attributes: attributes)
        channelDescriptionTextField.placeholderAttributedString = channelDescriptionPlaceholderAttributedString
        
        // Buttons
        createChannelButton.wantsLayer = true
        createChannelButton.layer?.backgroundColor = NSColor(named: "ToolbarColor")?.cgColor
        createChannelButton.layer?.cornerRadius = 10
    }
    
    @IBAction func closeButtonAction(_ sender: NSButton) {
        NotificationCenter.default.post(name: Constants.Notification.Name.closeModal, object: nil)
    }
    
    @IBAction func createChannelButtonAction(_ sender: NSButton) {
        WebSocketService.shared.addChannel(
            with: channelNameTextField.stringValue,
            channelDescription: channelDescriptionTextField.stringValue)
        
        NotificationCenter.default.post(name: Constants.Notification.Name.closeModal, object: nil)
    }
}
