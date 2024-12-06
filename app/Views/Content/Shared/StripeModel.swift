import SwiftUI
import StripePaymentSheet
import AppNotifications

class StripeModel: ObservableObject {
    var amount: String
    let backendCheckoutUrl = URL(string: "http://127.0.0.1:8080/create-payment-intent")! // Your backend endpoint
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    
    init(amount: String) {
        self.amount = amount
    }
    
    func preparePaymentSheet() {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["items": [["amount": Float(amount)! * 100]]], options: []) // Example request body
        
        print("dupa1")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
                  let self = self else {
                // Handle error
                return
            }
            
            print(json)
            
            print("dupa2")
            STPAPIClient.shared.publishableKey = "pk_test_51QFkxxP5t7Wyu7mQgeGKYm4dVd4plWB08OSiXa9vgui0S9wsQZgcjRBNvac7I27XvxU3MCXikuDuX3at3zUPkBSn0062b41nrg"
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Example, Inc."
            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment methods
            // that complete payment after a delay, like SEPA Debit and Sofort.
            configuration.allowsDelayedPaymentMethods = true
            
            DispatchQueue.main.async {
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
            }
        })
        task.resume()
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
    }
}

struct CheckoutView: View {
    var amount: String
//    var onDismiss: () -> Void
    
    @ObservedObject var model: StripeModel
    
    @Environment(\.presentationMode) var presentationMode: Binding
    
    init(amount: String) {
        self.amount = amount
//        self.onDismiss = onDismiss
        self.model = StripeModel(amount: amount)
    }
    
    public let cornerRadius: CGFloat = 12
    public let cellBackground: Color = Color.gray.opacity(0.2)
    public let cellHeight: CGFloat = 55
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Payment Summary")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            
            Text("Total Amount: PLN\(amount)")
                .font(.title2)
                .padding(.bottom, 20)
            
            Spacer()
            
            if let paymentSheet = model.paymentSheet {
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: { result in
                        model.onPaymentCompletion(result: result)
                        switch result {
                        case .completed:
                            AppNotifications.shared.notification = .init(success: "Payment complete")
                            self.presentationMode.wrappedValue.dismiss()
                        case .failed(let error):
                            AppNotifications.shared.notification = .init(error: "Payment failed: \(error.localizedDescription)")
                        case .canceled:
                            AppNotifications.shared.notification = .init(error: "Payment canceled.")
                        }
                    }
                ) {
                    Text("Pay")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(height: cellHeight)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(cornerRadius)
                }
            } else {
                Text("Loading…")
            }
        }
        .padding()
        .onAppear { model.preparePaymentSheet() }
//        .onDisappear {
//            onDismiss()
//        }
    }
}
