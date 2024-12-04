// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import ClerkSDK
import UIKit
import Combine
import SwiftUICore

@available(iOS 17.0, *)
public final class SdkClient: ObservableObject {
  
    static nonisolated(unsafe) public let shared: SdkClient = SdkClient()
    
    public init() {}
    
    public let API_URL = "http://localhost:8080"
}
