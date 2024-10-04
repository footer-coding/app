//
//  NavigationView.swift
//  app
//
//  Created by Tomasz on 04/10/2024.
//

import SwiftUI

struct NavigationView: View {
    var body: some View {
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


struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView()
        }
        .preferredColorScheme(.dark)
    }
}
