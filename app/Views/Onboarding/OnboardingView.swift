import SwiftUI

fileprivate struct InformationDetailView: View {
    var title: LocalizedStringKey = ""
    var subtitle: LocalizedStringKey = ""
    var imageName: String = ""
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.system(size: 50))
                .font(.largeTitle)
                .frame(width: 50)
                .foregroundColor(.accentColor)
                .padding()
                .accessibility(hidden: true)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)
                    .lineLimit(2)
                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}

struct OnboardingView: View {
    
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
    var body: some View {
            VStack() {
                Spacer()
                Image("WarSimulatorIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 162)
                    .cornerRadius(20)
                    .padding(.bottom, -40)
                
                Text("Welcome to WARCLE")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(height: 100)
                
                Spacer()
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        InformationDetailView(title: "Command Your Army", subtitle: "Lead your troops to victory in epic battles.", imageName: "shield")
                        InformationDetailView(title: "Strategize", subtitle: "Plan your moves and outsmart your enemies.", imageName: "map")
                        InformationDetailView(title: "Upgrade", subtitle: "Enhance your units and unlock new abilities.", imageName: "star")
                    }.multilineTextAlignment(.leading)
                    Spacer()
                }
                Spacer()
                Spacer()
                Button("Start Your Campaign") { needsAppOnboarding = false }
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(12)
            }.padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView().previewLayout(.fixed(width: 320, height: 640))
        }
    }
}
