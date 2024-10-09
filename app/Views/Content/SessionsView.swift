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
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    private func getSessionsFromClerk() {
        Task {
            do {
                try self.sessions = await clerk.user?.getSessions() ?? []
            } catch {
                print("Nie dziala")
            }
        }
    }
    
    var body: some View {
        HStack {
            HStack {
                if sessions != [] {
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
            }.task() {
                try? self.sessions = await clerk.user?.getSessions() ?? []
            }
        }
        .navigationBarTitle("Devices", displayMode: .inline)
    }
}

#Preview {
    SessionsView()
}
