//
//  SettingsView.swift
//  app
//
//  Created by Tomasz on 04/10/2024.
//

import SwiftUI
import ClerkSDK

struct SettingsView: View {
    
    @ObservedObject private var clerk = Clerk.shared
    @Environment(\.openURL) var openURL
    @State var alert: Bool = false
    @State var signOutAlert: Bool = false
    
    @State private var showEditSheet: Bool = false
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var image: URL = URL(string: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.z4no5tqp2ryBdMMD5NU9OgHaEv%26pid%3DApi&f=1&ipt=3ec8c522e4441118787208c74dbb632e38e9ca30ce05a05ef78d68e31be94a28&ipo=images")!
    @State private var imageUpdate: UIImage? = nil
   
    @State var isShowPicker: Bool = false
    @State var isImagePicked: Bool = false
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    private var appCredits: some View {
        HStack {
            Spacer()
            
            VStack {
                Group {
                    Text("Footer")
                    Text("")
                    Text("Made with ❤️ and ☕️")
                    Text("Coding Night 2024")
                }
                .font(.callout)
                .opacity(0.4)
                .multilineTextAlignment(.center)
            }
            .padding()
            
            Spacer()
        }
    }
    
    private var editHeader: some View {
        HStack {
            Spacer()
            Button(action: {
                isShowPicker.toggle()
            }) {
                VStack {
                    if (self.imageUpdate == nil) {
                        AsyncImage(url: $image,
                                   placeholder: { Image(systemName: "circle.dashed") },
                                   image: { Image(uiImage: $0).resizable() })
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                    } else {
                        Image(uiImage: self.imageUpdate!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())
                    }
                }
            }
            Spacer()
        }
    }
    
    private func hideEditSheet() {
        showEditSheet.toggle()
    }
    
    private var editAccount: some View {
        VStack {
            Form {
                Section(header: editHeader
                    .textCase(nil)
                    .foregroundColor(nil)) {}
                
                Section(header: Text("Username")) {
                    TextField("Username", text: $username)
                        .disabled(true)
                }
                
                Section(header: Text("Email"),
                        footer: Text("Your email address")) {
                    TextField("Email", text: $email)
                        .disabled(true)
                }
                
                Section(header: Text("Phone numer"),
                        footer: Text("Your phone number")) {
                    TextField("Phone number", text: $phoneNumber)
                        .disabled(true)
                }
            }
        }
        .onAppear {
            username = clerk.user?.username ?? "No username"
            email = clerk.user?.emailAddresses[0].emailAddress ?? "No email address"
            phoneNumber = clerk.user?.phoneNumbers[0].phoneNumber ?? "No phone number"
            image = URL(string: clerk.user?.imageUrl ?? "")!
        }
        .navigationTitle("Edit account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showEditSheet.toggle()
                }) {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showEditSheet.toggle()
                    if let url = URL(string: "https://fancy-manatee-69.accounts.dev/user") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Edit")
                }
            }
        }
        .navigationBarHidden(false)
    }
    
    private var formHeader: some View {
        VStack {
            AsyncImage(url: $image,
               placeholder: { Image(systemName: "circle.dashed") },
               image: { Image(uiImage: $0).resizable() })
                .frame(width: 130, height: 130)
                .clipShape(Circle())
            
            VStack {
                Text(username)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 1)
                    .foregroundColor(.primary)
                
                Text(self.email)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
            }
        }
    }
    
    func mailto(_ email: String) {
        let mailto = "mailto:\(email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(mailto ?? "")
        if let url = URL(string: mailto!) {
            openURL(url)
        }
    }
    
    var body: some View {
        if let user = clerk.user {
            VStack {
                HStack {
                    Button(action: {
                        showEditSheet.toggle()
                    }) {
                        Text("Account")
                    }.padding(.leading, 20)

                   
                    Spacer()
                    
                    Button("Sign Out") {
                        signOutAlert.toggle()
                    }.padding(.trailing, 20)
                }.padding(.top, 6)
                
                Form {
                    Section(header: formHeader
                        .textCase(nil)
                        .foregroundColor(nil)) {
                            NavigationLink(destination: SessionsView()) {
                                Label("Devices", systemImage: "laptopcomputer.and.iphone")
                                    .accessibility(label: Text("Devices"))
                            }
                            
                            NavigationLink(destination: PaymentsView()) {
                                Label("Payments", systemImage: "creditcard.fill")
                                    .accessibility(label: Text("Payments"))
                            }
                        }
                    
                    Section(footer: appCredits) {
                        NavigationLink(destination: ContributorsView()) {
                            Label("App developers team", systemImage: "person.2.fill")
                                .accessibility(label: Text("App developers team"))
                        }
                        
                        NavigationLink(destination: LicenceView()) {
                            Label("Open-source licences", systemImage: "books.vertical.fill")
                                .accessibility(label: Text("Open-source licences"))
                        }
                        
                        Button(action: {
                            alert.toggle()
                        }, label: {
                            Label {
                                Text("Contact")
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "envelope.fill")
                            }.accessibility(label: Text("Contact"))
                        })
                        
                    }
                }
                .background(Color("BackgroundColor"))
                .refreshable {
                    username = clerk.user?.username ?? "No username"
                    email = clerk.user?.emailAddresses[0].emailAddress ?? "No email address"
                    phoneNumber = clerk.user?.phoneNumbers[0].phoneNumber ?? "No phone number"
                    image = URL(string: clerk.user?.imageUrl ?? "")!
                }
            }
            .background(Color("BackgroundColor"))
            .onAppear {
                username = clerk.user?.username ?? "No username"
                email = clerk.user?.emailAddresses[0].emailAddress ?? "No email address"
                phoneNumber = clerk.user?.phoneNumbers[0].phoneNumber ?? "No phone number"
                image = URL(string: clerk.user?.imageUrl ?? "")!
            }
            .background(Color("BackgroundColor"))
            .sheet(isPresented: $showEditSheet) {
                NavigationView {
                    editAccount
                }
            }
            .alert("Do you want to email us?", isPresented: $alert, actions: {
                Button(action: {
                    mailto("pengwius@proton.me")
                }, label: {
                    Label("Email", systemImage: "envelope.fill")
                })
                Button("Cancel", role: .cancel, action: {})
            })
            .alert("Do you want to sign out?", isPresented: $signOutAlert, actions: {
                Button(role: .destructive, action: {
                    Task { try? await clerk.signOut() }
                }, label: {
                    Text("Sign out")
                })
                Button("Cancel", role: .cancel, action: {})
            })
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
