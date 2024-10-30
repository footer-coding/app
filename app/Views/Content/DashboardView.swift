//
//  DashboardView.swift
//  app
//
//  Created by Tomasz on 04/10/2024.
//

import SwiftUI
import ClerkSDK
import sdk

struct DashboardView: View {
    @State private var showModal = false
    
    @ObservedObject private var clerk = Clerk.shared
    
    public let cornerRadius: CGFloat = 12
    public let cellBackground: Color = Color.gray.opacity(0.2)

    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        if let user = clerk.user {
            ScrollView {
                Spacer()
                HStack {
                    Spacer()
                    Text("dawda")
                    Spacer()
                }
                Spacer()
            }
            .background(Color("BackgroundColor"))
            .toolbar {
                
            }
            .refreshable {
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
