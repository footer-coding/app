//
//  LoginView.swift
//  app
//
//  Created by Tomasz on 04/10/2024.
//

import SwiftUI
import ClerkSDK

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
                Image("etna")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 92)
                    .cornerRadius(20)
                    .padding(.bottom)
              
                Text("loginTitle")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
          
            Spacer()
          
            TextField("email", text: $email)
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
          
            TextField("password", text: $password)
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
          
            Button(buttonValue) {
                Task { await submit(email: email, password: password) }
            }.font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .frame(height: cellHeight)
            .frame(maxWidth: .infinity)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(cornerRadius)
      }.padding()
      .alert(isPresented: $showingAlert) {
          Alert(title: Text("accountRegistered"), message: Text("accountRegisteredContent"), dismissButton: .default(Text("OK")))}
        Spacer()
    }
}

extension LoginView {
    
  func submit(email: String, password: String) async {
    do {
      try await SignIn.create(
        strategy: .identifier(email, password: password)
      )
    } catch {
      dump(error)
    }
  }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
        }
        .preferredColorScheme(.dark)
    }
}
