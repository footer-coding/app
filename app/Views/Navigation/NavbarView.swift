//
//  NavbarView.swift
//  app
//
//  Created by Tomasz on 04/10/2024.
//

import SwiftUI

struct NavbarView: View {
    
    var body: some View {
        NavigationStack {
            TabView() {
                DashboardView()
                    .tabItem {
                        Label("dashboardButton", systemImage: "rectangle.on.rectangle")
                            .accessibility(label: Text("dashboardButton"))
                    }
                
                SettingsView()
                    .tabItem {
                        Label("settingsButton", systemImage: "gear")
                            .accessibility(label: Text("settingsButton"))
                    }
            }
        }
    }
}
