//
//  FindUserByEmailResponse.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 12.09.2022.
//

import Foundation

struct FindUserByEmailResponse: Codable {
    let id: String
    let name: String
    let email: String
    let avatarName: String
    let avatarColor: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case avatarName
        case avatarColor
    }
}
