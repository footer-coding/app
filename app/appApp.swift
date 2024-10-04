//
//  appApp.swift
//  app
//
//  Created by Tomasz on 04/10/2024.
//

import SwiftUI

@main
struct appApp: App {
    @AppStorage("isLogged") private var isLogged: Bool = false
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if(needsAppOnboarding) {
                OnboardingView()
            } else {
                NavigationView()
                    .onAppear {
                    }
            }
        }
    }
}
