//
//  AuthService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.09.2022.
//

import Foundation

struct AuthService {
    
    func registerAccount(with email: String, password: String) {
        let account = RegisterAccount(email: email, password: password)
        
        guard let url = URL(string: "\(Constants.URL.baseURL)\(Constants.Endpoint.registerAccount)"),
              let httpBody = try? JSONEncoder().encode(account) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error:")
                print("    \(error.localizedDescription)")
                print()
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }
            
            if let data = data {
                print("Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()
            }
        }.resume()
    }
    
    func loginUser(with email: String, password: String) {
        let account = LoginUser(email: email, password: password)
        
        guard let url = URL(string: "\(Constants.URL.baseURL)\(Constants.Endpoint.loginUser)"),
              let httpBody = try? JSONEncoder().encode(account) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error:")
                print("    \(error.localizedDescription)")
                print()
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }
            
            if let data = data {
                print("Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()
            }
        }.resume()
    }
    
    func addUser(with name: String, email: String, avatarName: String, avatarColor: String) {
        let account = AddUser(name: name, email: email, avatarName: avatarName, avatarColor: avatarColor)
        
        guard let url = URL(string: "\(Constants.URL.baseURL)\(Constants.Endpoint.addUser)"),
              let httpBody = try? JSONEncoder().encode(account) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error:")
                print("    \(error.localizedDescription)")
                print()
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }
            
            if let data = data {
                print("Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()
            }
        }.resume()
    }
}
