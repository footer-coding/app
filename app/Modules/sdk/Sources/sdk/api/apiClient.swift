//
//  apiClient.swift
//  sdk
//
//  Created by Tomasz on 22/10/2024.
//

import ClerkSDK

extension SdkClient {
   
     @MainActor public func isLogged() -> Bool {
        if let user = Clerk.shared.user {
            return true
        }
        
        return false
    }
    
    @MainActor public func getUsername() -> String? {
        return Clerk.shared.user?.username
    }
}
