//
//  LoginView.swift
//  app
//
//  Created by Tomasz on 04/10/2024.
//

import SwiftUI
import ClerkSDK
import AppNotifications

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @State public var clicked: Bool = false
    @State public var buttonValue = String(format: NSLocalizedString("loginButton", comment: "loginButton"))
    @State public var loginStatus: String = ""
    @State public var willMoveToNextScreen = false
    @State public var success = false
    @State public var showingAlert = false
    
    public let cellHeight: CGFloat = 55
    public let cornerRadius: CGFloat = 12
    public let cellBackground: Color = Color(UIColor.systemGray5).opacity(0.5)
    
    public let nullColor: Color = Color.accentColor.opacity(0.4)
    
    @Environment(\.presentationMode) var presentationMode: Binding
    
    private func setColor(input: String) -> Color {
        if(clicked == true){
            switch(input) {
            case "email":
                if (email == "") {
                    return nullColor
                } else {
                    return cellBackground
                }
                
            case "password":
                if (password == "") {
                    return nullColor
                } else {
                    return cellBackground
                }
                
            default:
                return cellBackground
            }
        } else {
            return cellBackground
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image("NoBackgroundIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 162)
                .cornerRadius(20)
                .padding(.bottom, -40)
            
            Text("Log in")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Spacer()
            
            TextField("Email or username", text: $email)
                .autocapitalization(.none)
                .font(Font.body.weight(Font.Weight.medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: cellHeight)
                .background(cellBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(setColor(input: "username"), lineWidth: 2)
                )
            
            SecureField("Password", text: $password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(Font.body.weight(Font.Weight.medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: cellHeight)
                .background(cellBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(setColor(input: "password"), lineWidth: 2)
                )
            
            Link("Don't have an account? Sign Up", destination: URL(string: "https://fancy-manatee-69.accounts.dev/sign-up")!)
            
            Spacer()
            Spacer()
            
            Button("Log in") {
                Task {
                    do {
                        try await SignIn.create(
                            strategy: .identifier(email, password: password)
                        )
                        
                        AppNotifications.shared.notification = .init(success: "Successfuly logged in!")
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        AppNotifications.shared.notification = .init(error: "Wrong creditials")
                    }
                }
            }.font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: cellHeight)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor.opacity(0.2))
                .cornerRadius(cornerRadius)
        }.padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("accountRegistered"), message: Text("accountRegisteredContent"), dismissButton: .default(Text("OK")))}
        Spacer()
    }
}
