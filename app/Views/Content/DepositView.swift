import SwiftUI
import ClerkSDK
import QRCode
import sdk

struct DepositView: View {
    @ObservedObject private var clerk = Clerk.shared
    
    @State private var bitcoinAddress: String? = nil
//    @Binding var isPresented: Bool
    
    public let cornerRadius: CGFloat = 12
    public let cellBackground: Color = Color.gray.opacity(0.2)
    public let cellHeight: CGFloat = 55
    public let tileSize: CGFloat = 100
    
    @State private var amount = ""
    @State private var selectedPaymentMethod: String? = nil
    @State private var showAmountView = false
    @State private var navigateToBitcoinCheckout = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var onProceedToCheckout: (String) -> Void
    
    func generateQRCode(from string: String) -> UIImage? {
        do {
            let qrCodeData = try QRCode.Builder()
                .text(string)
                .quietZonePixelCount(3)
                .foregroundColor(CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1))
                .backgroundColor(CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1))
                .background.cornerRadius(3)
                .onPixels.shape(QRCode.PixelShape.CurvePixel())
                .eye.shape(QRCode.EyeShape.Teardrop())
                .generate.image(dimension: 600, representation: .png())
            
            return UIImage(data: qrCodeData)
        } catch {
            print("Failed to generate QR code: \(error)")
            return nil
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if showAmountView {
                    Spacer()
                    
                    Text("Deposit Amount")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 100)
                    
                    HStack {
                        Text("PLN")
                            .font(Font.body.weight(Font.Weight.medium))
                        TextField("Amount in PLN", text: $amount)
                            .autocapitalization(.none)
                            .font(Font.body.weight(Font.Weight.medium))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .cornerRadius(cornerRadius)
                            .padding(.trailing, 34)
                    }
                    .padding(.horizontal)
                    .frame(height: cellHeight)
                    .background(cellBackground)
                    .cornerRadius(cornerRadius)
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        onProceedToCheckout(amount)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Proceed to Checkout")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(height: cellHeight)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor.opacity(0.2))
                            .cornerRadius(cornerRadius)
                    }
                } else if navigateToBitcoinCheckout {
                    VStack {
                        if let bitcoinAddress = bitcoinAddress {
                            Text("Send Bitcoin to the following address:")
                                .font(.headline)
                                .padding(.bottom, 10)
                            
                            HStack {
                                TextField("Bitcoin Address", text: .constant(bitcoinAddress))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(true)
                                
                                Button(action: {
                                    UIPasteboard.general.string = bitcoinAddress
                                }) {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.bottom, 20)
                            
                            if let qrCodeImage = generateQRCode(from: bitcoinAddress) {
                                Image(uiImage: qrCodeImage)
                                    .interpolation(.none)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .padding(.bottom, 20)
                            }
                            
                            Text("Scan the QR code to send the payment.")
                                .font(.subheadline)
                                .padding(.bottom, 10)
                            
                            Spacer()
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Done")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .frame(height: cellHeight)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.accentColor.opacity(0.2))
                                    .cornerRadius(cornerRadius)
                            }
                            
                        } else {
                            Text("Loading Bitcoin address...")
                                .font(.headline)
                                .padding()
                        }
                    }
                    .padding()
                    .onAppear {
                        SdkClient.shared.getBitcoinAddress { address in
                            DispatchQueue.main.async {
                                self.bitcoinAddress = address
                            }
                        }
                    }
                } else {
                    Spacer()
                    
                    Text("Choose Payment Method")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 100)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Image("bitcoin")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.bottom, 5)
                            
                            Text("Bitcoin")
                                .font(.headline)
                        }
                        .frame(width: tileSize, height: tileSize)
                        .padding()
                        .background(selectedPaymentMethod == "Bitcoin" ? Color.blue.opacity(0.2) : Color.white)
                        .cornerRadius(cornerRadius)
                        .onTapGesture {
                            selectedPaymentMethod = "Bitcoin"
                        }
                        
                        VStack {
                            Image(systemName: "creditcard")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding(.bottom, 5)
                            
                            Text("Card")
                                .font(.headline)
                        }
                        .frame(width: tileSize, height: tileSize)
                        .padding()
                        .background(selectedPaymentMethod == "Card" ? Color.blue.opacity(0.2) : Color.white)
                        .cornerRadius(cornerRadius)
                        .onTapGesture {
                            selectedPaymentMethod = "Card"
                        }
                    }
                    .padding(.bottom, 20)
                   
                    Spacer()
                    
//                    NavigationLink(destination: BitcoinCheckoutView(isPresented: $navigateToBitcoinCheckout), isActive: $navigateToBitcoinCheckout) {
//                        EmptyView()
//                    }
                    
                    Button(action: {
                        if selectedPaymentMethod == "Bitcoin" {
                            navigateToBitcoinCheckout = true
                        } else if selectedPaymentMethod != nil {
                            showAmountView = true
                        }
                    }) {
                        Text("Confirm")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(height: cellHeight)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor.opacity(0.2))
                            .cornerRadius(cornerRadius)
                    }
                }
            }
            .padding()
        }
    }
}
