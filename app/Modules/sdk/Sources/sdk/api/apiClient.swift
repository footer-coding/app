//
//  apiClient.swift
//  sdk
//
//  Created by Tomasz on 22/10/2024.
//

import ClerkSDK
import Foundation

extension SdkClient {
    
    @MainActor private func request(request: URLRequest, completion: @escaping @Sendable (Result<JSON, Error>) -> Void) {
        var request = request
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if(error?._code.littleEndian == -1004) {
                completion(.failure(SdkError.NoInternetConnection))
            } else {
                guard let data = data else {
                    if let _ = error {
                        completion(.failure(ApiError.UnexpectedError))
                    }
                    return
                }
                
                do {
                    let responseBody = try JSON(data)
                    if(responseBody["success"] == true) {
                        completion(.success(responseBody))
                    } else {
                        completion(.failure(SdkError.UnexpectedError))
                    }
                    
                } catch {
                    completion(.failure(SdkError.ResponseParseError))
                }
            }
        }.resume()
    }
    
    @MainActor public func sendToApi(cos: String) async {
        let urlString: String = "\(SdkClient.shared.API_URL)/addToDb"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let payload = ["cos": cos]
        
        do {
            let jsonPayload = try JSONSerialization.data(withJSONObject: payload)
            request.httpBody = jsonPayload
            
            let tokenOptions = Session.GetTokenOptions(template: "JWT")
            
            print(tokenOptions)
            
            if let token = try await Clerk.shared.session?.getToken(tokenOptions)?.jwt {
                print(token)
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            self.request(request: request) { result in
                switch result {
                case .success(let json):
                    print("Success: \(json)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }
    
    @MainActor public func getBitcoinAddress(completion: @escaping (String?) -> Void) {
        let urlString: String = "\(SdkClient.shared.CRYPTO_API_URL)/generate_address"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        Task {
            do {
                let tokenOptions = Session.GetTokenOptions(template: "JWT")
                print(tokenOptions)
                
                if let token = try await Clerk.shared.session?.getToken(tokenOptions)?.jwt {
                    print(token)
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Status Code: \(httpResponse.statusCode)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Failed to parse JSON response")
                    completion(nil)
                    return
                }
                
                print("Success: \(json)")
                
                if let address = json["address"] as? String {
                    print("Bitcoin Address: \(address)")
                    completion(address)
                } else {
                    print("Address not found in response")
                    completion(nil)
                }
                
            } catch {
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    @MainActor public func getBalance(completion: @escaping (Double?) -> Void) {
        let urlString: String = "\(SdkClient.shared.API_URL)/get-balance"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        Task {
            do {
                let tokenOptions = Session.GetTokenOptions(template: "JWT")
                print(tokenOptions)
                
                if let token = try await Clerk.shared.session?.getToken(tokenOptions)?.jwt {
                    print(token)
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Status Code: \(httpResponse.statusCode)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Failed to parse JSON response")
                    completion(nil)
                    return
                }
                
                print("Success: \(json)")
                
                if let balance = json["balance"] as? Double {
                    print("Balance: \(balance)")
                    completion(balance)
                } else {
                    print("Balance not found in response")
                    completion(nil)
                }
                
            } catch {
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    @MainActor public func getTransactionsHistory(completion: @escaping ([[String: Any]]?) -> Void) {
        let urlString: String = "\(SdkClient.shared.API_URL)/transaction-history"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        Task {
            do {
                let tokenOptions = Session.GetTokenOptions(template: "JWT")
                print(tokenOptions)
                
                if let token = try await Clerk.shared.session?.getToken(tokenOptions)?.jwt {
                    print(token)
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Status Code: \(httpResponse.statusCode)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    print("Failed to parse JSON response")
                    completion(nil)
                    return
                }
                
                print("Success: \(json)")
                
                completion(json)
                
            } catch {
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    @MainActor public func purchaseFullVersion(completion: @escaping (Bool?) -> Void) {
        let urlString: String = "\(SdkClient.shared.API_URL)/purchase-full-version"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        Task {
            do {
                let tokenOptions = Session.GetTokenOptions(template: "JWT")
                print(tokenOptions)
                
                if let token = try await Clerk.shared.session?.getToken(tokenOptions)?.jwt {
                    print(token)
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Status Code: \(httpResponse.statusCode)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    print("Failed to parse JSON response")
                    completion(nil)
                    return
                }
                
                print("Success: \(json)")
                
                completion(true)
                
            } catch {
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
}
