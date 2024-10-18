//
//  SessionsView.swift
//  app
//
//  Created by Tomasz on 09/10/2024.
//

import SwiftUI
import ClerkSDK

struct SessionsView: View {
    @State private var sessions: [Session] = []
    
    @ObservedObject private var clerk = Clerk.shared
    
    private func loadSessions() {
        Task {
            if let userSessions = try? await Clerk.shared.user?.getSessions() {
                sessions = userSessions
            }
        }
    }
    
    var body: some View {
        HStack {
            NavigationStack {
                HStack {
                    if (sessions != []) {
                        Form {
                            ForEach(sessions) { session in
                                HStack {
                                    HStack {
                                        Label(session.latestActivity?.browserName ?? "Noname", systemImage: "macbook.and.iphone")
                                            .accessibility(label: Text(session.latestActivity?.browserName ?? "Noname"))
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text(session.latestActivity?.ipAddress ?? "No IP address")
                                            .accessibility(label: Text(session.latestActivity?.ipAddress ?? "No IP address"))
                                    }
                                }
                            }
                        }
                    } else {
                        Text("Loading...")
                    }
                }.onAppear {
                    loadSessions()
                }
            }
        }
        .navigationBarTitle("Devices", displayMode: .inline)
    }
}
