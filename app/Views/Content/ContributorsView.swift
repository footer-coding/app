//
//  ContributorsView.swift
//  app
//
//  Created by Tomasz on 09/10/2024.
//

import SwiftUI

struct ContributorsView: View {

    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State private var pengwiusURL: URL = URL(string: "https://avatars.githubusercontent.com/u/55411338?v=4")!
    @State private var Sajms0nURL: URL = URL(string: "https://avatars.githubusercontent.com/u/120739534?v=4")!
    @State private var kube3qqURL: URL = URL(string: "https://avatars.githubusercontent.com/u/183517417?v=4")!
    @State private var toasterURL: URL = URL(string: "https://avatars.githubusercontent.com/u/105929223?v=4")!
    
    
    var body: some View {
        Form {
            HStack {
                AsyncImage(url: $pengwiusURL,
                               placeholder: { Image(systemName: "circle.dashed") },
                               image: { Image(uiImage: $0).resizable() })
                    .frame(width: 38, height: 38)
                    .cornerRadius(10)
                Link("Pengwius", destination: URL(string: "https://github.com/pengwius")!)
                    .foregroundColor(Color("CustomForegroundColor"))
            }
            
            HStack {
                AsyncImage(url: $Sajms0nURL,
                               placeholder: { Image(systemName: "circle.dashed") },
                               image: { Image(uiImage: $0).resizable() })
                    .frame(width: 38, height: 38)
                    .cornerRadius(10)
                Link("Sajms0n", destination: URL(string: "https://github.com/Sajms0n")!)
                    .foregroundColor(Color("CustomForegroundColor"))
            }
            
            HStack {
                AsyncImage(url: $kube3qqURL,
                               placeholder: { Image(systemName: "circle.dashed") },
                               image: { Image(uiImage: $0).resizable() })
                    .frame(width: 38, height: 38)
                    .cornerRadius(10)
                Link("kube3qq", destination: URL(string: "https://github.com/kube3qq")!)
                    .foregroundColor(Color("CustomForegroundColor"))
            }
            
            HStack {
                AsyncImage(url: $toasterURL,
                               placeholder: { Image(systemName: "circle.dashed") },
                               image: { Image(uiImage: $0).resizable() })
                    .frame(width: 38, height: 38)
                    .cornerRadius(10)
                Link("ToasterCoder44", destination: URL(string: "https://github.com/ToasterCoder44")!)
                    .foregroundColor(Color("CustomForegroundColor"))
            }
        }.navigationBarTitle("App developers", displayMode: .inline)
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    ContributorsView()
}
