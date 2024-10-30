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
}
