//
//  LicenceView.swift
//  app
//
//  Created by Tomasz on 09/10/2024.
//

import SwiftUI

struct LicenceView: View {
    
    let ClerkIOS: String = """
    MIT License

    Copyright (c) 2023 Clerk

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
    """
    
    let ClerkIOSURL: URL? = URL(string: "https://github.com/clerk/clerk-ios")!
    
    var body: some View {
        List {
            DisclosureGroup("Clerk iOS") {
                Text(ClerkIOS)
                    .font(.system(.body, design: .monospaced))
                    .onTapGesture {
                        guard let url = ClerkIOSURL else { return }
                        UIApplication.shared.open(url)
                    }
            }
            .padding(.vertical)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Text("Licences"))
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    LicenceView()
}
