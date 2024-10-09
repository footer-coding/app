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
    
    @State private var showEditSheet: Bool = false
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var image: String = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.z4no5tqp2ryBdMMD5NU9OgHaEv%26pid%3DApi&f=1&ipt=3ec8c522e4441118787208c74dbb632e38e9ca30ce05a05ef78d68e31be94a28&ipo=images"
   
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
                    AsyncImage(url: URL(string: image)!,
                       placeholder: { Image(systemName: "circle.dashed") },
                       image: { Image(uiImage: $0).resizable() })
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                    
                    
                    Button(action: {
                        isShowPicker.toggle()
                    }) {
                        Text("Change avatar")
                    }
                }
            }
            Spacer()
        }
    }
    
    private var editAccount: some View {
        VStack {
            Form {
                Section(header: editHeader
                    .textCase(nil)
                    .foregroundColor(nil)) {}
                
                Section(header: Text("Username")) {
                    TextField("Username", text: $username)
                }
                
                Section(header: Text("Email"),
                        footer: Text("Your email address")) {
                    TextField("Email", text: $email)
                }
                
                Section(header: Text("Phone numer"),
                        footer: Text("Your phone number")) {
                    TextField("Phone number", text: $phoneNumber)
                }
            }
        }
        .onAppear {
            username = clerk.user?.username ?? "No username"
            email = clerk.user?.emailAddresses[0].emailAddress ?? "No email address"
            //            image = UIImage(data: account.avatar!)!
            phoneNumber = clerk.user?.phoneNumbers[0].phoneNumber ?? "No phone number"
            image = clerk.user?.imageUrl ?? ""
        }
        .sheet(isPresented: $isShowPicker) {
            //            ImagePicker(image: self.$image, isImagePicked: self.$isImagePicked)
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
                    
                }) {
                    Text("Done")
                }
            }
        }
        .navigationBarHidden(false)
    }
    
    private var formHeader: some View {
        VStack {
            AsyncImage(url: URL(string: image)!,
               placeholder: { Image(systemName: "circle.dashed") },
               image: { Image(uiImage: $0).resizable() })
//                .resizable()
//                .aspectRatio(contentMode: .fill)
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
                        Text("Edit")
                    }.padding(.leading, 20)

                   
                    Spacer()
                    
                    Button("Sign Out") {
                        Task { try? await clerk.signOut() }
                    }.padding(.trailing, 20)
                }
                
                Form {
                    Section(header: formHeader
                        .textCase(nil)
                        .foregroundColor(nil)) {
                            NavigationLink(destination: SessionsView()) {
                                Label("Devices", systemImage: "laptopcomputer.and.iphone")
                                    .accessibility(label: Text("Devices"))
                            }
                            
                            NavigationLink(destination: PrivacyView()) {
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
            }
            //.navigationBarTitle("Settings", displayMode: .inline)
            //        .navigationBarTitle(account.username ?? "<username can't be loaded>", displayMode: .inline)
            .background(Color("BackgroundColor"))
            .onAppear {
                username = clerk.user?.username ?? "No username"
                email = clerk.user?.emailAddresses[0].emailAddress ?? "No email address"
                //            image = UIImage(data: account.avatar!)!
                phoneNumber = clerk.user?.phoneNumbers[0].phoneNumber ?? "No phone number"
                image = clerk.user?.imageUrl ?? ""
            }
            .background(Color("BackgroundColor"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out ") {
                        Task { try? await clerk.signOut() }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showEditSheet.toggle()
                    }) {
                        Text(" Edit")
                    }
                }
            }
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
            .toolbarVisibility(.visible)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
        }
        .preferredColorScheme(.dark)
    }
}
