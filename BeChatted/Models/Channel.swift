//
//  Channel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.10.2022.
//

import Foundation

struct Channel: Decodable {
    let id: String
    let name: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
    }
}
