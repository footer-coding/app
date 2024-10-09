//
//  DashboardView.swift
//  app
//
//  Created by Tomasz on 04/10/2024.
//

import SwiftUI
import ClerkSDK

struct DashboardView: View {
    @State private var showModal = false
    
    @ObservedObject private var clerk = Clerk.shared
    
    public let cornerRadius: CGFloat = 12
    public let cellBackground: Color = Color.gray.opacity(0.2)
    
    var body: some View {
        if let user = clerk.user {
            ScrollView {
                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                    print("Refreshing..")
                }
                
                VStack {
                    Text("dawda")
                    Button("Sign Out") {
                        Task { try? await clerk.signOut() }
                    }
                }
            }
        } else {
            VStack {
                Text("notLoggedIn")
                NavigationLink("logIn") {
                    LoginView()
                }
            }.padding()
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardView()
        }
        .preferredColorScheme(.dark)
    }
}
