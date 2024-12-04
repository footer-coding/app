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
    
    @State public var selectedCurrency: String = "US Dollar"
    
    var body: some View {
        VStack {
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
                                Text("US Dollar")
                                    .foregroundColor(.blue)
                                    .tag("US Dollar")
                                Text("Polish PLN")
                                    .foregroundColor(.blue)
                                    .tag("Polish PLN")
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
            
            Form {
                Section(header: Text("Transactions")) {
                    Text("cos tu bedzie")
                    Text("cos tu bedzie")
                    Text("cos tu bedzie")
                    Text("cos tu bedzie")
                }
            }.padding(.top, -10)
            
            VStack {
                HStack {
                    NavigationLink(destination: CheckoutView()) {
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
        }.background(Color("BackgroundColor"))
    }
}
