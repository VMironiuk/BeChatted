//
//  MessageService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.10.2022.
//

import Foundation

final class MessageService {
    static let shared = MessageService()
    
    private(set) var channels: [Channel] = []
    private(set) var messages: [Message] = []
    
    private init() {}
    
    func loadChannels(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.URL.baseURL)\(Constants.Endpoint.findAllChannels)") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(AuthService.shared.authToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("[findAllChannels: Error:")
                print("    \(error.localizedDescription)")
                print()
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("[findAllChannels]: Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }

            if let data = data {
                print("[findAllChannels]: Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()
                
                guard let channels = (try? JSONDecoder().decode([Channel].self, from: data)) else {
                    completion(.success(false))
                    return
                }
                
                self.channels = channels
                
                channels.forEach { print($0.name) }
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func loadMessages(by channelId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.URL.baseURL)\(Constants.Endpoint.findMessagesByChannel)\(channelId)") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(AuthService.shared.authToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("[loadMessages: Error:")
                print("    \(error.localizedDescription)")
                print()
                completion(.failure(error))
                return
            }

            if let response = response as? HTTPURLResponse {
                print("[loadMessages]: Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }

            if let data = data {
                print("[loadMessages]: Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()
                
                guard let messages = (try? JSONDecoder().decode([Message].self, from: data)) else {
                    completion(.success(false))
                    return
                }
                
                self.messages = messages
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func sendMessage(_ message: AddMessage, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.URL.baseURL)\(Constants.Endpoint.addMessage)"),
              let httpBody = try? JSONEncoder().encode(message) else { return }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(AuthService.shared.authToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("[sendMessage]: Error:")
                print("    \(error.localizedDescription)")
                print()
                completion(.failure(error))
                return
            }

            if let response = response as? HTTPURLResponse {
                print("[sendMessage]: Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }

            if let data = data {
                print("[sendMessage]: Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()
                completion(.success(true))
                return
            }

            completion(.success(false))
        }.resume()
    }
}
