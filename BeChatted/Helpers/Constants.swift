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
            static let closeModal = NSNotification.Name("BCHCloseModalNotificationName")
            static let loggedInUserDidChange = NSNotification.Name("BCHLoggedInUserDidChangeNotificationName")
        }
    }
    
    struct UserInfoKey {
        private init() {}
        
        static let modalType = "ModalType"
    }
    
    struct URL {
        private init() {}
        
        static let baseURL = "http://localhost:3005"
    }
    
    struct Endpoint {
        private init() {}
        
        static let registerAccount = "/v1/account/register"
        static let loginUser = "/v1/account/login"
        static let addUser = "/v1/user/add"
        static let findUserByEmail = "/v1/user/byEmail/"
    }
}
