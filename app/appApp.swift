//
//  appApp.swift
//  app
//
//  Created by Tomasz on 04/10/2024.
//

import SwiftUI
import ClerkSDK
import AppNotifications

@main
struct appApp: App {
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
    @ObservedObject private var clerk = Clerk.shared
    @StateObject private var appNotifications: AppNotifications = AppNotifications.shared
    
    var body: some Scene {
        WindowGroup {
            if(needsAppOnboarding) {
                OnboardingView()
            } else {
                ZStack {
                    if clerk.loadingState == .notLoaded {
                        Text("Loading...")
                    } else {
                        NavbarView()
                            .onAppear {
                            }
                            .environmentObject(appNotifications)
                            .notificationOverlay(appNotifications)

                    }
                }.task {
                    clerk.configure(publishableKey: "pk_test_ZmFuY3ktbWFuYXRlZS02OS5jbGVyay5hY2NvdW50cy5kZXYk")
                    try? await clerk.load()
                }
            }
        }
    }
}
