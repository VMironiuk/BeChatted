//
//  ChannelCellView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 07.10.2022.
//

import Cocoa

class ChannelCellView: NSTableCellView {

    @IBOutlet private weak var channelNameTextField: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func configure(with channel: Channel) {
        channelNameTextField.stringValue = "#\(channel.name)"
    }
}
