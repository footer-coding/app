//
//  PaymentsView.swift
//  app
//
//  Created by Tomasz on 15/10/2024.
//

import SwiftUI

struct PaymentsView: View {
    
    public let cornerRadius: CGFloat = 12
    public let cellBackground: Color = Color.gray.opacity(0.2)
    public let cellHeight: CGFloat = 55
    
    @State public var selectedCurrency: String = "Polish PLN"
    @State private var showDepositView = false
    @State private var navigateToCheckout = false
    @State private var amount: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                accountBalanceSection
                transactionsSection
                actionsSection
            }
            .background(Color("BackgroundColor"))
        }
        .sheet(isPresented: $showDepositView) {
            DepositView(onProceedToCheckout: { amount in
                self.amount = amount
                self.navigateToCheckout = true
            })
        }
        .background(
            NavigationLink(destination: {
                if let amount = amount {
                    AnyView(CheckoutView(amount: amount))
                } else {
                    AnyView(EmptyView())
                }
            }(), isActive: $navigateToCheckout) {
                EmptyView()
            }
            .hidden()
        )
    }
    
    private var accountBalanceSection: some View {
        VStack {
            VStack {
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                Text("Account balance")
                                    .font(.footnote)
                                
                                Spacer()
                            }.padding(.bottom, -2)
                            
                            HStack {
                                if (selectedCurrency == "US Dollar") {
                                    Text("$213769.69")
                                        .font(.title)
                                } else {
                                    Text("PLN 213769.69")
                                        .font(.title)
                                }
          
                                Spacer()
                            }.padding(.top, -2)
                        }.padding(.leading)
                       
                        if (selectedCurrency == "US Dollar") {
                            Image("usflag")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 38, height: 38)
                                .clipShape(Circle())
                                .padding(.trailing)
                        } else {
                            Image("plflag")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 38, height: 38)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                        
                    }
                    .frame(width: .infinity, alignment: .leading)
                    .padding(.top)
                    .cornerRadius(cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.gray.opacity(0), lineWidth: 2)
                    )
                    .cornerRadius(cornerRadius)
                    .padding(.bottom, 4)
                    
                    Divider()
                    
                    HStack {
                        Button(action: {
                            print("See more")
                        }) {
                            Text("See more")
                                .font(.callout)
                        }.padding(.leading)
                        
                        Spacer()
                        
                        Picker(selectedCurrency, selection: $selectedCurrency) {
                            Text("Polish PLN")
                                .foregroundColor(.blue)
                                .tag("Polish PLN")
                            Text("US Dollar")
                                .foregroundColor(.blue)
                                .tag("US Dollar")
                        }.font(.callout)
                        .padding(.top, 0)
                    }
                    .padding(.top, 4)
                    .padding(.bottom, -4)
                }
                .navigationBarTitle("Payments", displayMode: .inline)
                .frame(width: .infinity, alignment: .leading)
                .padding([.leading, .trailing, .bottom])
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.gray.opacity(0), lineWidth: 2)
                )
                .background(Color("TileColor"))
                .cornerRadius(cornerRadius)
            }.padding()
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.gray.opacity(0), lineWidth: 2)
                )
                .cornerRadius(cornerRadius)
        }.padding([.leading, .trailing], 3)
        .padding(.bottom, 0)
    }
    
    private var transactionsSection: some View {
        Form {
            Section(header: Text("Transactions")) {
                Text("cos tu bedzie")
                Text("cos tu bedzie")
                Text("cos tu bedzie")
                Text("cos tu bedzie")
            }
        }.padding(.top, -10)
    }
    
    private var actionsSection: some View {
        VStack {
            HStack {
                Button(action: {
                    showDepositView = true
                }) {
                    Text("Deposit")
                }.font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(height: cellHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor.opacity(0.2))
                    .cornerRadius(cornerRadius)
                
                Button("Withdrawal") {
                    print("withdrawal")
                }.font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(height: cellHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor.opacity(0.2))
                    .cornerRadius(cornerRadius)
            }.padding([.leading, .trailing])
            .background(Color("BackgroundColor"))
        }.padding([.leading, .trailing], 3)
    }
}
