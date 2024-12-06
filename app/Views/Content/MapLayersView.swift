import SwiftUI

struct MapLayersView: View {
    @Binding var showFriendlyUnits: Bool
    @Binding var showHostileUnits: Bool
    @Binding var showControlZones: Bool

    var body: some View {
        VStack {
            Toggle("Show Friendly Units", isOn: $showFriendlyUnits)
            Toggle("Show Hostile Units", isOn: $showHostileUnits)
            Toggle("Show Control Zones", isOn: $showControlZones)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
