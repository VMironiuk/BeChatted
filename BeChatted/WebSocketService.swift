//
//  WebSocketService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 22.09.2022.
//

import Cocoa
import SocketIO

class WebSocketService: NSObject {

    static let shared = WebSocketService()
    
    private let socket: SocketIOClient
    
    private override init() {
        let url = URL(string: Constants.URL.baseURL)!
        let socketManager = SocketManager(socketURL: url, config: [.log(true), .compress])
        socket = socketManager.defaultSocket
        
        super.init()
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
}
