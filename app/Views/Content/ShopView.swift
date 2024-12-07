import SwiftUI
import sdk
import AppNotifications

struct ShopView: View {
    @State private var selectedOption: Int? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let cellHeight: CGFloat = 50
    private let cornerRadius: CGFloat = 10
    
    private var header: some View {
        VStack {
            Image(systemName: "cart.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.blue)
                .padding(.bottom, 10)
            
            Text("Shop Options")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Choose the best option for your needs")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var footer: some View {
        VStack {
            Divider()
            Text("Prices are shown in PLN (Polish Zloty)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                header
                
                Form {
                    Section(header: Text("Choose your plan")
                        .font(.headline)
                        .foregroundColor(.primary)) {
                        RadioButton(id: 1, label: "Buy full access - 80zł", isSelected: selectedOption == 1) {
                            selectedOption = 1
                        }
                        
                        RadioButton(id: 2, label: "Buy unlimited military units - 40zł", isSelected: selectedOption == 2) {
                            selectedOption = 2
                        }
                        
                        RadioButton(id: 3, label: "Set of both - 120zł", isSelected: selectedOption == 3) {
                            selectedOption = 3
                        }
                    }
                    
                    Section {
                        Button(action: {
                            Task {
                                await handlePurchase()
                            }
                        }) {
                            Text("Proceed to Payment")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .frame(height: cellHeight)
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor.opacity(0.2))
                                .cornerRadius(cornerRadius)
                        }
                        .disabled(selectedOption == nil)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color("BackgroundColor"))
                
                footer
            }
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Purchase Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func handlePurchase() async {
        guard let selectedOption = selectedOption else { return }
        
        if selectedOption == 1 {
            do {
                Task {
                    try await SdkClient.shared.purchaseFullVersion { success in
                        AppNotifications.shared.notification = .init(success: "Purchase successful!")
                    }
                }
                alertMessage = "Purchase successful!"
            } catch {
                alertMessage = "Purchase failed: \(error.localizedDescription)"
            }
            showAlert = true
        } else {
            // Handle other purchase options if needed
            alertMessage = "This option is not implemented yet."
            showAlert = true
        }
    }
}

struct RadioButton: View {
    let id: Int
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(label)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ShopView()
}
