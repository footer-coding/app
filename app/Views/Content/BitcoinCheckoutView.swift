import SwiftUI
import QRCode
import sdk

struct BitcoinCheckoutView: View {
    @State private var bitcoinAddress: String? = nil
    @Binding var isPresented: Bool
    
    public let cornerRadius: CGFloat = 12
    public let cellBackground: Color = Color.gray.opacity(0.2)
    public let cellHeight: CGFloat = 55
    public let tileSize: CGFloat = 100
    
    var body: some View {
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
                    isPresented = false
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
    }
    
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
}
