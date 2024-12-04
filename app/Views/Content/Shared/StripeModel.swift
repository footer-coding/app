//
//  StripeModel.swift
//  app
//
//  Created by Tomasz on 04/12/2024.
//

import StripePaymentSheet
import SwiftUI

class StripeModel: ObservableObject {
  let backendCheckoutUrl = URL(string: "http://127.0.0.1:8080/create-payment-intent")! // Your backend endpoint
  @Published var paymentSheet: PaymentSheet?
  @Published var paymentResult: PaymentSheetResult?

  func preparePaymentSheet() {
    // MARK: Fetch the PaymentIntent and Customer information from the backend
    var request = URLRequest(url: backendCheckoutUrl)
    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            let customerId = json["customer"] as? String,
            let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
            let paymentIntentClientSecret = json["paymentIntent"] as? String,
            let publishableKey = json["publishableKey"] as? String,
            let self = self else {
        // Handle error
        return
      }

      STPAPIClient.shared.publishableKey = publishableKey
      // MARK: Create a PaymentSheet instance
      var configuration = PaymentSheet.Configuration()
      configuration.merchantDisplayName = "Example, Inc."
      configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
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
  @ObservedObject var model = StripeModel()

  var body: some View {
    VStack {
      if let paymentSheet = model.paymentSheet {
        PaymentSheet.PaymentButton(
          paymentSheet: paymentSheet,
          onCompletion: model.onPaymentCompletion
        ) {
          Text("Buy")
        }
      } else {
        Text("Loading…")
      }
      if let result = model.paymentResult {
        switch result {
        case .completed:
          Text("Payment complete")
        case .failed(let error):
          Text("Payment failed: \(error.localizedDescription)")
        case .canceled:
          Text("Payment canceled.")
        }
      }
    }.onAppear { model.preparePaymentSheet() }
  }
}
