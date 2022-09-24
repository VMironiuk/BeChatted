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
    
    private let socketManager: SocketManager
    private let socket: SocketIOClient
    
    private override init() {
        let url = URL(string: Constants.URL.baseURL)!
        socketManager = SocketManager(socketURL: url, config: [.log(true), .compress, .forceWebsockets(true)])
        socket = socketManager.defaultSocket
        
        super.init()
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func addChannel(with channelName: String, channelDescription: String) {
        socket.emit("newChannel", channelName, channelDescription)
    }
}
