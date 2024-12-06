//
//  ManageView.swift
//  app
//
//  Created by Szymon Dacków on 06/12/2024.
//

import SwiftUI

struct ManageView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: MapView()) {
                    Text("Go to Map")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: PaymentsView()) {
                    Text("Go to Payments")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Manage")
        }
    }
}

struct ManageView_Previews: PreviewProvider {
    static var previews: some View {
        ManageView()
    }
}
