//
//  AuthService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.09.2022.
//

import Foundation

typealias AuthServiceCompletion = (Result<Bool, Error>) -> Void

final class AuthService {
    static let shared = AuthService()
    
    private(set) var authToken: String = ""
    private(set) var currentUser: CurrentUser = CurrentUser(name: "", email: "")
    private(set) var isLoggedIn: Bool = false
    
    private init() {}
    
    func registerAccount(withEmail email: String, password: String, completion: @escaping AuthServiceCompletion) {
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
                print("[registerAccount]: Error:")
                print("    \(error.localizedDescription)")
                print()
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("[registerAccount]: Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }
            
            if let data = data {
                print("[registerAccount]: Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()
                completion(.success(true))
                return
            }
            
            completion(.success(false))
        }.resume()
    }
    
    func loginUser(withEmail email: String, password: String, completion: @escaping AuthServiceCompletion) {
        let account = LoginUser(email: email, password: password)
        
        guard let url = URL(string: "\(Constants.URL.baseURL)\(Constants.Endpoint.loginUser)"),
              let httpBody = try? JSONEncoder().encode(account) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let error = error {
                print("[loginUser]: Error:")
                print("    \(error.localizedDescription)")
                print()
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("[loginUser]: Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }
            
            if let data = data {
                print("[loginUser]: Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()
                
                guard let loginUserResponse = try? JSONDecoder().decode(LoginUserResponse.self, from: data) else {
                    completion(.success(false))
                    return
                }
                self?.authToken = loginUserResponse.token
                completion(.success(true))
                return
            }
            
            completion(.success(false))
        }.resume()
    }
    
    func addUser(
        withName name: String,
        email: String,
        avatarName: String,
        avatarColor: String,
        completion: @escaping AuthServiceCompletion
    ) {
        let account = AddUser(name: name, email: email, avatarName: avatarName, avatarColor: avatarColor)
        
        guard let url = URL(string: "\(Constants.URL.baseURL)\(Constants.Endpoint.addUser)"),
              let httpBody = try? JSONEncoder().encode(account) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("[addUser]: Error:")
                print("    \(error.localizedDescription)")
                print()
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("[addUser]: Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }
            
            if let data = data {
                print("[addUser]: Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()
                completion(.success(true))
                return
            }
            
            completion(.success(false))
        }.resume()
    }
    
    func findUser(byEmail email: String, completion: @escaping AuthServiceCompletion) {
        guard let url = URL(string: "\(Constants.URL.baseURL)\(Constants.Endpoint.findUserByEmail)\(email)") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let error = error {
                print("[findUserByEmail]: Error:")
                print("    \(error.localizedDescription)")
                print()
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("[findUserByEmail]: Response:")
                print("    Status Code: \(response.statusCode)")
                print()
            }
            
            if let data = data {
                print("[findUserByEmail]: Data:")
                print("    \(String(decoding: data, as: UTF8.self))")
                print()

                guard let findUserByEmailResponse = try? JSONDecoder().decode(FindUserByEmailResponse.self, from: data) else {
                    completion(.success(false))
                    return
                }
                
                self?.currentUser = CurrentUser(name: findUserByEmailResponse.name, email: findUserByEmailResponse.email)
                self?.isLoggedIn = true
                completion(.success(true))
                print(findUserByEmailResponse.name)
                print(findUserByEmailResponse.email)
                return
            }
            
            completion(.success(false))
        }.resume()
    }
}
