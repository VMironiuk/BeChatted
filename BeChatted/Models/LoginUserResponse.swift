//
//  LoginUserResponse.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 08.09.2022.
//

import Foundation

struct LoginUserResponse: Codable {
    let user: String
    let token: String
}
