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
}
