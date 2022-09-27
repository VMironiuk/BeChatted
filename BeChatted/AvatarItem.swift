//
//  AvatarItem.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 27.09.2022.
//

import Cocoa

class AvatarItem: NSCollectionViewItem {

    @IBOutlet private weak var avatarImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func update(image: NSImage?) {
        avatarImageView.image = image
    }
}
