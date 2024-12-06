//
//  DepositView.swift
//  app
//
//  Created by Tomasz on 04/12/2024.
//

import SwiftUI
import ClerkSDK

struct DepositView: View {
    @ObservedObject private var clerk = Clerk.shared
    
    public let cornerRadius: CGFloat = 12
    public let cellBackground: Color = Color.gray.opacity(0.2)
    public let cellHeight: CGFloat = 55
    
    @State private var amount = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var onProceedToCheckout: (String) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Deposit Amount")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            
            HStack {
                Text("PLN")
                    .font(Font.body.weight(Font.Weight.medium))
                TextField("Amount in PLN", text: $amount)
                    .autocapitalization(.none)
                    .font(Font.body.weight(Font.Weight.medium))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .cornerRadius(cornerRadius)
                    .padding(.trailing, 34)
            }
            .padding(.horizontal)
            .frame(height: cellHeight)
            .background(cellBackground)
            .cornerRadius(cornerRadius)
            .padding(.bottom, 20)
            
            Spacer()
           
            Button(action: {
                onProceedToCheckout(amount)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Proceed to Checkout")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(height: cellHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor.opacity(0.2))
                    .cornerRadius(cornerRadius)
            }
            
            Spacer()
        }
        .padding()
    }
}
