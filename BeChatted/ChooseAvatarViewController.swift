//
//  ChooseAvatarViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 27.09.2022.
//

import Cocoa

class ChooseAvatarViewController: NSViewController {

    @IBOutlet private weak var collectionView: NSCollectionView!
    
    private let avatarItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "AvatarItem")
    
    override var nibName: NSNib.Name? {
        "ChooseAvatarView"
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ChooseAvatarView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(AvatarItem.self, forItemWithIdentifier: avatarItemIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

extension ChooseAvatarViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        28
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        itemForRepresentedObjectAt indexPath: IndexPath
    ) -> NSCollectionViewItem {
        let avatarItem = collectionView.makeItem(withIdentifier: avatarItemIdentifier, for: indexPath) as! AvatarItem
        avatarItem.update(image: NSImage(named: "dark0"))
        return avatarItem
    }
    
}

extension ChooseAvatarViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> NSSize {
        NSSize(width: 85, height: 85)
    }
}
