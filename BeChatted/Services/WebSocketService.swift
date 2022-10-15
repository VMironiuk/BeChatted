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
    
    func addMessage(_ message: AddMessage) {
        socket.emit(
            "newMessage",
            message.messageBody,
            message.userId,
            message.channelId,
            message.userName,
            message.userAvatar,
            message.userAvatarColor)
    }
    
    func fetchMessage(completion: @escaping (Result<Message, Error>) -> Void) {
        socket.on("messageCreated") { array, _ in
            guard let messageBody = array[0] as? String,
                  let userId = array[1] as? String,
                  let channelId = array[2] as? String,
                  let userName = array[3] as? String,
                  let userAvatar = array[4] as? String,
                  let userAvatarColor = array[5] as? String,
                  let messageId = array[6] as? String,
                  let timestamp = array[7] as? String else {
                return { completion(.failure(NSError(domain: "Fetch message error", code: 1000))) }()
            }
            
            completion(.success(Message(
                id: messageId,
                messageBody: messageBody,
                userId: userId,
                channelId: channelId,
                userName: userName,
                userAvatar: userAvatar,
                userAvatarColor: userAvatarColor,
                timeStamp: timestamp)))
        }
    }
}
