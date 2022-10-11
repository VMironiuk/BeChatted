//
//  AddMessage.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.10.2022.
//

import Foundation

struct AddMessage: Encodable {
    let messageBody: String
    let userId: String
    let channelId: String
    let userName: String
    let userAvatar: String
    let userAvatarColor: String
    
    private enum CodingKeys: String, CodingKey {
        case messageBody
        case userId
        case channelId
        case userName
        case userAvatar
        case userAvatarColor
    }
}
