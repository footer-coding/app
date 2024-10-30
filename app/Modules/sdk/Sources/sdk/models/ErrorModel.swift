//
//  ErrorModel.swift
//  sdk
//
//  Created by Tomasz on 22/10/2024.
//

import Foundation

extension SdkClient {
    
    public enum ApiError: Error {
        case UnexpectedError
    }
    
    public enum SdkError: Error {
            case UnexpectedError
            
            // Request parsing
            case ResponseParseError
            case NoInternetConnection
        }
    
    // MARK: - Errors functions
    
    func parseErrorCode(errorCode: Int) -> ApiError {
        switch errorCode {
            case 0:     return ApiError.UnexpectedError
            
            default:    return ApiError.UnexpectedError
        }
    }
}
