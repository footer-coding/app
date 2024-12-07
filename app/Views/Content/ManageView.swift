import SwiftUI

struct ManageView: View {
    // Define custom color for blue
    let customBlue = Color(red: 46 / 255, green: 142 / 255, blue: 206 / 255)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [customBlue.opacity(0.6), Color.white.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Text("Manage Options")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(customBlue)
                        .padding(.top, 20)
                    
                    NavigationLink(destination: MapView()) {
                        HStack {
                            Image(systemName: "map.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Go to Map")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [customBlue, Color.white]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .cornerRadius(15)
                        .shadow(color: customBlue.opacity(0.4), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                    
                    NavigationLink(destination: ShopView()) {
                        HStack {
                            Image(systemName: "cart.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Go to Shop")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [customBlue, Color.white]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .cornerRadius(15)
                        .shadow(color: customBlue.opacity(0.4), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
        }
    }
}

struct ManageView_Previews: PreviewProvider {
    static var previews: some View {
        ManageView()
    }
}
