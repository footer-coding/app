//
//  PaymentsView.swift
//  app
//
//  Created by Tomasz on 15/10/2024.
//

import SwiftUI
import sdk

struct PaymentsView: View {
    
    struct Transaction: Identifiable {
        let id = UUID()
        let date: Date
        let amount: Double
        let status: String
        let type: String
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    public let cornerRadius: CGFloat = 12
    public let cellBackground: Color = Color.gray.opacity(0.2)
    public let cellHeight: CGFloat = 55
    
    @State public var selectedCurrency: String = "Polish PLN"
    @State private var showDepositView = false
    @State private var navigateToCheckout = false
    @State private var amount: String? = nil
    @State private var balance: Double = 0
    @State private var transactionsHistory: [Transaction] = []
    
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
        .refreshable {
            Task {
                await SdkClient.shared.getBalance { balance in
                    self.balance = balance ?? 0
                }
                await SdkClient.shared.getTransactionsHistory { transactions in
                    self.transactionsHistory = transactions?.map { dict in
                        Transaction(
                            date: parseDate(dict["date"] as? String ?? ""),
                            amount: dict["amount"] as? Double ?? 0.0,
                            status: dict["status"] as? String ?? "Unknown",
                            type: dict["type"] as? String ?? "Deposit"
                        )
                    }.sorted(by: { $0.date > $1.date }) ?? []
                }
            }
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
    
    private var usdBalance: some View {
        Text("$\(String(format: "%.2f", balance / 4 / 100))")
            .font(.title)
    }
    
    private var plnBalance: some View {
        Text("\(String(format: "%.2f", balance / 100)) PLN")
            .font(.title)
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
                                   usdBalance
                                } else {
                                    plnBalance
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
        .onAppear() {
            Task {
                await SdkClient.shared.getBalance { balance in
                    self.balance = balance ?? 0
                }
                
                await SdkClient.shared.getTransactionsHistory { transactions in
                    self.transactionsHistory = transactions?.map { dict in
                        Transaction(
                            date: parseDate(dict["date"] as? String ?? ""),
                            amount: dict["amount"] as? Double ?? 0.0,
                            status: dict["status"] as? String ?? "Unknown",
                            type: dict["type"] as? String ?? "Deposit"
                        )
                    }.sorted(by: { $0.date > $1.date }) ?? []
                }
            }
        }
    }
    
    private var transactionsSection: some View {
        Form {
            Section(header: Text("Transactions")) {
                ForEach(transactionsHistory) { transaction in
                    HStack {
                        Image(systemName: "creditcard.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 38, height: 38)
                            .clipShape(Circle())
                            .padding(.trailing)
                            .foregroundColor(.accentColor)
                        
                        VStack(alignment: .leading) {
                            Text(transaction.type)
                                .font(.headline)
                            
                            Text(formatDate(transaction.date))
                                .font(.caption2)
                            
                            HStack {
                                let statusColor: Color = transaction.status == "confirmed" ? .green : .orange
                                Image(systemName: transaction.status == "confirmed" ? "checkmark.circle" : "arrow.trianglehead.clockwise")
                                    .font(.caption)
                                    .foregroundColor(statusColor)
                                
                                Text(transaction.status)
                                    .font(.caption)
                                    .foregroundColor(statusColor)
                                    .padding(.leading, -6)
                            }
                        }
                        
                        Spacer()
                        
                        Text("+\(String(format: "%.2f", transaction.amount/100)) PLN")
                            .foregroundColor(transaction.status == "confirmed" ? .green : .orange)
                    }
                }
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
