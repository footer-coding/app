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
    public let cellHeight: CGFloat = 55
    
    @State private var cos = ""
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        if let user = clerk.user {
            ScrollView {
                Spacer()
                VStack {
                    HStack {
                        Spacer()
                        Text("dawda")
                        Spacer()
                    }
                    
                    TextField("Wpisz cos", text: $cos)
                        .autocapitalization(.none)
                        .font(Font.body.weight(Font.Weight.medium))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(height: cellHeight)
                        .background(cellBackground)
                    
                    Button("Wyslij") {
                        Task {
                            await SdkClient.shared.sendToApi(cos: cos)
                        }
                    }.font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(height: cellHeight)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(cornerRadius)
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
