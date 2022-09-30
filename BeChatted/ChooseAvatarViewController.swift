//
//  ChooseAvatarViewController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 27.09.2022.
//

import Cocoa

enum AvatarType: Int {
    case light
    case dark
}

protocol ChooseAvatarViewControllerDelegate: AnyObject {
    func chooseAvatarViewController(
        _ viewController: ChooseAvatarViewController,
        didSelectItemWithAvatarName avatarName: String)
}

class ChooseAvatarViewController: NSViewController {

    @IBOutlet private weak var collectionView: NSCollectionView!
    @IBOutlet private weak var segmentedControl: NSSegmentedControl!
    
    private var avatarType: AvatarType {
        AvatarType(rawValue: segmentedControl.indexOfSelectedItem)!
    }
    
    private let avatarItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "AvatarItem")
    
    override var nibName: NSNib.Name? {
        "ChooseAvatarView"
    }
    
    weak var delegate: ChooseAvatarViewControllerDelegate?
        
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
    
    @IBAction func segmentedControlAction(_ sender: NSSegmentedControl) {
        collectionView.reloadData()
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
        if avatarType == .light {
            avatarItem.update(image: NSImage(named: "light\(indexPath.item)"))
        } else {
            avatarItem.update(image: NSImage(named: "dark\(indexPath.item)"))
        }
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

extension ChooseAvatarViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else { return }
        if avatarType == .light {
            delegate?.chooseAvatarViewController(self, didSelectItemWithAvatarName: "light\(indexPath.item)")
        } else {
            delegate?.chooseAvatarViewController(self, didSelectItemWithAvatarName: "dark\(indexPath.item)")
        }
        view.window?.cancelOperation(nil)
    }
}
