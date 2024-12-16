//
//  WebService.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 12/11/24.
//

import Foundation

enum AuthenticationError: Error, Equatable {
    case invalidCredentials
    case incompleteBody
    case custom(errorMessage: String)
}

enum OAuthError: Error {
    case invalidURL
}

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
    case invalidResponse
    case userNotFound
    case custom(errorMessage: String)
}

struct LoginRequestBody: Codable {
    let emailorusername: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String?
    let users: User?
    let success: Bool?
}

struct SignUpResponse: Codable {
    let success: Bool?
    let result: SignUpResultData?
}

struct SignUpResultData: Codable {
    let u_id: Int
    let u_uid: String
    let u_fullname: String
    let u_username: String
    let u_email: String
    let u_balance: Int
    let u_salt: String
    let u_password: String
    let u_resetPasswordToken: String?
    let u_resetPasswordExpires: String?
    let u_created_at: String
    let u_updated_at: String
    let u_is_deleted: Bool
}

struct GetUserResponse: Codable {
    let success: Bool?
    let result: User?
}

struct AddTransactionResponse: Codable {
    let success: Bool?
    let data: Transaction?
}

struct GetTransactionResponse: Codable {
    let success: Bool?
    let data: [Transaction]?
}

class WebService {
    
    var baseURL = "https://finance-tracking-app-api-service-743940785467.asia-southeast2.run.app/"
    
    func login(emailorusername: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> ()) {
        
        guard let url = URL(string: "\(baseURL)user/login") else {
            completion(.failure(.custom(errorMessage: "URL invalid")))
            return
        }
                
        let body = LoginRequestBody(emailorusername: emailorusername, password: password)
                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.custom(errorMessage: "Invalid response from server")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 401 {
                    completion(.failure(.invalidCredentials))
                } else {
                    completion(.failure(.custom(errorMessage: "Error \(httpResponse.statusCode)")))
                }
                return
            }
                
            guard let data = data else {
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
            
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            guard let token = loginResponse.token else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            completion(.success(token))
        }.resume()
    }

    func startOAuth(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let oauthURL = URL(string: "\(baseURL)user/google") else {
            completion(.failure(OAuthError.invalidURL))
            return
        }
        
        // Return the OAuth URL to the caller
        completion(.success(oauthURL))
    }
    
    func signup(body: SignUpRequestBody,
                completion: @escaping (Result<String, AuthenticationError>) -> ()) {
        
        guard let url = URL(string: "\(baseURL)user/") else {
            completion(.failure(.custom(errorMessage: "URL invalid")))
            return
        }
                                                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
                        
        URLSession.shared.dataTask(with: request) { data, response, error in
                
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
                                                
            guard let signUpResponse = try? JSONDecoder().decode(SignUpResponse.self, from: data) else {
                completion(.failure(.custom(errorMessage: "Failure decoding response")))
                return
            }
                                    
            let encoder = JSONEncoder()
                
            guard let resultData = try? encoder.encode(signUpResponse.result) else {
                completion(.failure(.custom(errorMessage: "Error")))
                return
            }
                                    
            guard let result = try? JSONDecoder().decode(SignUpResultData.self, from: resultData) else {
                completion(.failure(.custom(errorMessage: "Failure decoding UID")))
                return
            }

            completion(.success(result.u_uid))
        }.resume()
    }
    
    func getUser(token: String, completion: @escaping (Result<User, NetworkError>) -> ()) {
        guard let url = URL(string: "\(baseURL)user") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
                                    
            guard let response = try? JSONDecoder().decode(GetUserResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            guard let user = response.result else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(user))
            
        }.resume()
    }
    
    func addTransaction(token: String, body: TransactionRequestBody, completion: @escaping (Result<String, NetworkError>) -> ()) {
        guard let url = URL(string: "\(baseURL)transaction/") else {
            completion(.failure(.invalidURL))
            return
        }
                                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
                                    
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 404 {
                    completion(.failure(.userNotFound))
                } else {
                    completion(.failure(.custom(errorMessage: "Error \(httpResponse.statusCode)")))
                }
                return
            }
            completion(.success("Transaction added!"))
        }.resume()
    }
    
    func updateTransaction(token: String, uid:String, body: TransactionRequestBody, completion: @escaping (Result<String, NetworkError>) -> ()) {
        var components = URLComponents(string: "\(baseURL)transaction")!
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: uid))
        
        components.queryItems = queryItems

        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
                                    
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 404 {
                    completion(.failure(.userNotFound))
                } else {
                    completion(.failure(.custom(errorMessage: "Error \(httpResponse.statusCode)")))
                }
                return
            }
            completion(.success("Transaction updated!"))
        }.resume()
    }
    
    func getAllTransactions(token: String, month:String? = nil, category:String? = nil, completion: @escaping (Result<[Transaction], NetworkError>)->()) {
        var components = URLComponents(string: "\(baseURL)transaction/")!
        
        var queryItems: [URLQueryItem] = []

        if month != nil {
            queryItems.append(URLQueryItem(name: "month", value: month))
        }
        
        if category != nil {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
                              
        components.queryItems = queryItems
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
                                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 404 {
                    completion(.failure(.userNotFound))
                } else {
                    completion(.failure(.custom(errorMessage: "Error \(httpResponse.statusCode)")))
                }
                return
            }
            
            guard let responseBody = try? JSONDecoder().decode(GetTransactionResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
                                    
            completion(.success(responseBody.data ?? []))
        }.resume()
        
    }
    
    func deleteTransaction(token: String, uid: String, completion: @escaping (Result<Bool, NetworkError>) -> ()) {
        
        var components = URLComponents(string: "\(baseURL)transaction")!
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: uid))
        
        components.queryItems = queryItems

        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            
            guard error == nil else {
                completion(.failure(.noData))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 404 {
                    completion(.failure(.userNotFound))
                } else {
                    completion(.failure(.custom(errorMessage: "Error \(httpResponse.statusCode)")))
                }
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func forgotPassword(email: String, completion: @escaping (Result<String, NetworkError>) -> ()) {
        guard let url = URL(string: "\(baseURL)user/forgot-password") else {
            completion(.failure(.custom(errorMessage: "URL invalid")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email]

        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { _, response, _ in
                                    
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 404 {
                    completion(.failure(.userNotFound))
                } else {
                    completion(.failure(.custom(errorMessage: "Error \(httpResponse.statusCode)")))
                }
                return
            }
            completion(.success("Email sent!"))
        }.resume()
        
        
    }
    
}

