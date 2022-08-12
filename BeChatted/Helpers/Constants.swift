//
//  Constants.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 12.08.2022.
//

import Foundation

struct Constants {
    private init() {}
    
    struct Notification {
        private init() {}
        
        struct Name {
            private init() {}
            
            static let showModal = NSNotification.Name("BCHShowModalNotificationName")
        }
    }
    
    struct UserInfoKey {
        private init() {}
        
        static let modalType = "ModalType"
    }
}
