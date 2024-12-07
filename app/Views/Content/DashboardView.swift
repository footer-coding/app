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
                VStack(spacing: 20) {
                    Text("Witaj Generale!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accentColor)
                    
                    Text("Twoim zadaniem jest poprowadzenie swojej armii do zwycięstwa w symulacji! Masz określoną ilość jednostek, którymi możesz dowodzić, aby osiągnąć sukces.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(cellBackground)
                        .cornerRadius(cornerRadius)
                    
                    Text("Jeśli nie wykupisz dostępu, masz do dyspozycji jedną symulację dziennie. Po wykupieniu dostępu uzyskasz możliwość wykonywania nieograniczonej liczby symulacji.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(cellBackground)
                        .cornerRadius(cornerRadius)
                    
                    Text("Możesz także dokupić jednostki, co pozwoli Ci dowodzić nieograniczoną ilością żołnierzy!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(cellBackground)
                        .cornerRadius(cornerRadius)
                    
              
                    
                    // Zachowano TextField i Button do przesyłania danych do API
//                    TextField("Wpisz coś", text: $cos)
//                        .autocapitalization(.none)
//                        .font(Font.body.weight(Font.Weight.medium))
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                        .frame(height: cellHeight)
//                        .background(cellBackground)
//                    
//                    Button("Wyślij") {
//                        Task {
//                            await SdkClient.shared.sendToApi(cos: cos)
//                        }
//                    }
//                    .font(.headline)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//                    .frame(height: cellHeight)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.accentColor.opacity(0.2))
//                    .cornerRadius(cornerRadius)
                }
                .padding()
                Spacer()
            }
            .background(Color("BackgroundColor"))
            .toolbar {
                // Miejsce na ewentualne elementy paska narzędzi
            }
            .refreshable {
                // Miejsce na ewentualne odświeżanie
            }
        } else {
            VStack {
                Text("Nie jesteś zalogowany")
                    .font(.headline)
                    .padding()
                NavigationLink("Zaloguj się") {
                    LoginView()
                }
                .font(.headline)
                .padding()
                .background(Color.accentColor.opacity(0.2))
                .cornerRadius(cornerRadius)
            }.padding()
        }
    }
    
   
}
