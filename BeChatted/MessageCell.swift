//
//  MessageCell.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 13.10.2022.
//

import Cocoa

class MessageCell: NSTableCellView {

    @IBOutlet private weak var avatarImageView: NSImageView!
    @IBOutlet private weak var nameLabel: NSTextField!
    @IBOutlet private weak var dateLabel: NSTextField!
    @IBOutlet private weak var messageLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func configure(with message: Message) {
        avatarImageView.wantsLayer = true
        avatarImageView.layer?.borderWidth = 1
        avatarImageView.layer?.borderColor = NSColor.unemphasizedSelectedTextBackgroundColor.cgColor
        avatarImageView.layer?.cornerRadius = 7
        
        avatarImageView.image = NSImage(named: message.userAvatar)
        nameLabel.stringValue = message.userName
        dateLabel.stringValue = message.timeStamp
        messageLabel.stringValue = message.messageBody
    }
}
