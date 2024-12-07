import SwiftUI
import MapKit

enum MapItem: Identifiable {
    case checkpoint(Checkpoint)
    case tank(Tank)
    case soldier(Soldier)
    case plane(Plane)
    
    var id: UUID {
        switch self {
        case .checkpoint(let checkpoint):
            return checkpoint.id
        case .tank(let tank):
            return tank.id
        case .soldier(let soldier):
            return soldier.id
        case .plane(let plane):
            return plane.id
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .checkpoint(let checkpoint):
            return checkpoint.coordinate
        case .tank(let tank):
            return tank.coordinate
        case .soldier(let soldier):
            return soldier.coordinate
        case .plane(let plane):
            return plane.coordinate
        }
    }
}

struct Checkpoint: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct Tank: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    let amount: Int
    var currentCheckpointIndex: Int = 0
}

struct Soldier: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    let amount: Int
    var currentCheckpointIndex: Int = 0
}

struct Plane: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    let amount: Int
    var currentCheckpointIndex: Int = 0
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var checkpoints: [Checkpoint] = []
    @State private var tanks: [Tank] = []
    @State private var soldiers: [Soldier] = []
    @State private var planes: [Plane] = []
    @State private var drawRoute = false
    @State private var addingTanks = false
    @State private var addingSoldiers = false
    @State private var addingPlanes = false
    @State private var addingCheckpoints = false
    @State private var amount = 1
    @State private var timer: Timer?
    @State private var showControls = false
    
    private let maxZoomOutDelta: CLLocationDegrees = 180.0 // Maximum zoom out level
    
    var body: some View {
        VStack {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: mapItems) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        VStack {
                            switch item {
                            case .checkpoint:
                                Circle()
                                    .strokeBorder(Color.blue, lineWidth: 2)
                                    .background(Circle().foregroundColor(Color.blue.opacity(0.3)))
                                    .frame(width: 10, height: 10)
                            case .tank(let tank):
                                Image("military-tank")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.green)
                                Text("\(tank.amount)")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            case .soldier(let soldier):
                                Image("NoBackgroundIcon")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.brown)
                                Text("\(soldier.amount)")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            case .plane(let plane):
                                Image("fighter-jet")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                                Text("\(plane.amount)")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newCoordinate = convertToCoordinate(from: value.location, in: region)
                                    switch item {
                                    case .checkpoint(let checkpoint):
                                        if let index = checkpoints.firstIndex(where: { $0.id == checkpoint.id }) {
                                            checkpoints[index].coordinate = newCoordinate
                                        }
                                    case .tank(let tank):
                                        if let index = tanks.firstIndex(where: { $0.id == tank.id }) {
                                            tanks[index].coordinate = newCoordinate
                                        }
                                    case .soldier(let soldier):
                                        if let index = soldiers.firstIndex(where: { $0.id == soldier.id }) {
                                            soldiers[index].coordinate = newCoordinate
                                        }
                                    case .plane(let plane):
                                        if let index = planes.firstIndex(where: { $0.id == plane.id }) {
                                            planes[index].coordinate = newCoordinate
                                        }
                                    }
                                }
                        )
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    let location = region.center
                    if addingTanks {
                        tanks.append(Tank(coordinate: location, amount: amount))
                    } else if addingSoldiers {
                        soldiers.append(Soldier(coordinate: location, amount: amount))
                    } else if addingPlanes {
                        planes.append(Plane(coordinate: location, amount: amount))
                    } else if addingCheckpoints {
                        checkpoints.append(Checkpoint(coordinate: location))
                    }
                }
                
                if drawRoute && checkpoints.count > 1 {
                    RoutePath(checkpoints: checkpoints, region: region)
                        .stroke(Color.red, lineWidth: 2)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showControls.toggle()
                            }
                        }) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
                
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: zoomIn) {
                                Image(systemName: "plus.magnifyingglass")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            Button(action: zoomOut) {
                                Image(systemName: "minus.magnifyingglass")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                        }
                        .padding()
                    }
                    Spacer()
                }
                
                if showControls {
                    VStack {
                        Spacer()
                        VStack {
                            HStack {
                                controlButton(title: drawRoute ? "Hide Route" : "Draw Route", action: { drawRoute.toggle(); showControls = false })
                            }
                            .padding(.bottom, 5)
                            
                            HStack {
                                controlButton(title: "Tanks", action: {
                                    addingTanks = true
                                    addingSoldiers = false
                                    addingPlanes = false
                                    addingCheckpoints = false
                                    showControls = false
                                })
                                controlButton(title: "Soldiers", action: {
                                    addingTanks = false
                                    addingSoldiers = true
                                    addingPlanes = false
                                    addingCheckpoints = false
                                    showControls = false
                                })
                                controlButton(title: "Planes", action: {
                                    addingTanks = false
                                    addingSoldiers = false
                                    addingPlanes = true
                                    addingCheckpoints = false
                                    showControls = false
                                })
                                controlButton(title: "Checkpoint", action: {
                                    addingTanks = false
                                    addingSoldiers = false
                                    addingPlanes = false
                                    addingCheckpoints = true
                                    showControls = false
                                })
                                controlButton(title: "Reset", action: { reset(); showControls = false })
                            }
                            .padding(.bottom, 5)
                            
                            HStack {
                                Text("Amount:")
                                    .foregroundColor(.blue)
                                TextField("Amount", value: $amount, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 60)
                                    .padding()
                            }
                            
                            HStack {
                                controlButton(title: "Start", action: { startMoving(); showControls = false }, textColor: .green)
                                controlButton(title: "Stop", action: { stopMoving(); showControls = false }, textColor: .red)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding()
                    }
                }
            }
        }
    }
    
    private var mapItems: [MapItem] {
        return checkpoints.map { MapItem.checkpoint($0) } +
               tanks.map { MapItem.tank($0) } +
               soldiers.map { MapItem.soldier($0) } +
               planes.map { MapItem.plane($0) }
    }
    
    private func controlButton(title: String, action: @escaping () -> Void, textColor: Color = .blue) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.white)
                .foregroundColor(textColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .cornerRadius(8)
                .lineLimit(1) // Ensure text does not wrap
        }
    }
    
    private func zoomIn() {
        var span = region.span
        span.latitudeDelta /= 2
        span.longitudeDelta /= 2
        region.span = span
    }
    
    private func zoomOut() {
        var span = region.span
        span.latitudeDelta = min(span.latitudeDelta * 2, maxZoomOutDelta)
        span.longitudeDelta = min(span.longitudeDelta * 2, maxZoomOutDelta)
        region.span = span
    }
    
    private func reset() {
        checkpoints.removeAll()
        tanks.removeAll()
        soldiers.removeAll()
        planes.removeAll()
        drawRoute = false
        addingTanks = false
        addingSoldiers = false
        addingPlanes = false
        addingCheckpoints = false
        timer?.invalidate()
        timer = nil
    }
    
    private func convertToCoordinate(from point: CGPoint, in region: MKCoordinateRegion) -> CLLocationCoordinate2D {
        let mapPoint = MKMapPoint(x: Double(point.x), y: Double(point.y))
        return mapPoint.coordinate
    }
    
    private func startMoving() {
        print("Start Moving called")
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            moveItems()
        }
    }
    
    private func stopMoving() {
        print("Stop Moving called")
        timer?.invalidate()
        timer = nil
    }
    
    private func moveItems() {
        print("Move Items called")
        guard checkpoints.count > 1 else { return }
        
        var updatedTanks = tanks
        var updatedSoldiers = soldiers
        var updatedPlanes = planes
        
        for i in 0..<updatedTanks.count {
            let nextCheckpoint = checkpoints[updatedTanks[i].currentCheckpointIndex].coordinate
            updatedTanks[i].coordinate = moveTowards(current: updatedTanks[i].coordinate, target: nextCheckpoint)
            if updatedTanks[i].coordinate == nextCheckpoint {
                if updatedTanks[i].currentCheckpointIndex == checkpoints.count - 1 {
                    // Stop moving if it's the last checkpoint
                    continue
                }
                updatedTanks[i].currentCheckpointIndex = (updatedTanks[i].currentCheckpointIndex + 1) % checkpoints.count
            }
        }
        
        for i in 0..<updatedSoldiers.count {
            let nextCheckpoint = checkpoints[soldiers[i].currentCheckpointIndex].coordinate
            updatedSoldiers[i].coordinate = moveTowards(current: updatedSoldiers[i].coordinate, target: nextCheckpoint)
            if updatedSoldiers[i].coordinate == nextCheckpoint {
                if updatedSoldiers[i].currentCheckpointIndex == checkpoints.count - 1 {
                    // Stop moving if it's the last checkpoint
                    continue
                }
                updatedSoldiers[i].currentCheckpointIndex = (updatedSoldiers[i].currentCheckpointIndex + 1) % checkpoints.count
            }
        }
        
        for i in 0..<updatedPlanes.count {
            let nextCheckpoint = checkpoints[updatedPlanes[i].currentCheckpointIndex].coordinate
            updatedPlanes[i].coordinate = moveTowards(current: updatedPlanes[i].coordinate, target: nextCheckpoint)
            if updatedPlanes[i].coordinate == nextCheckpoint {
                if updatedPlanes[i].currentCheckpointIndex == checkpoints.count - 1 {
                    // Stop moving if it's the last checkpoint
                    continue
                }
                updatedPlanes[i].currentCheckpointIndex = (updatedPlanes[i].currentCheckpointIndex + 1) % checkpoints.count
            }
        }
        
        // Update the state with the new positions
        tanks = updatedTanks
        soldiers = updatedSoldiers
        planes = updatedPlanes
    }
    
    private func moveTowards(current: CLLocationCoordinate2D, target: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let latDiff = target.latitude - current.latitude
        let lonDiff = target.longitude - current.longitude
        let distance = sqrt(latDiff * latDiff + lonDiff * lonDiff)
        
        guard distance > 0.0001 else { return target }
        
        let step = 0.0001 / distance
        let newLat = current.latitude + latDiff * step
        let newLon = current.longitude + lonDiff * step
        
        return CLLocationCoordinate2D(latitude: newLat, longitude: newLon)
    }
}

struct RoutePath: Shape {
    var checkpoints: [Checkpoint]
    var region: MKCoordinateRegion
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard let firstCheckpoint = checkpoints.first else {
            return path
        }
        
        let startPoint = convertToMapPoint(coordinate: firstCheckpoint.coordinate, region: region, rect: rect)
        path.move(to: startPoint)
        
        for checkpoint in checkpoints.dropFirst() {
            let point = convertToMapPoint(coordinate: checkpoint.coordinate, region: region, rect: rect)
            path.addLine(to: point)
        }
        
        return path
    }
    
    private func convertToMapPoint(coordinate: CLLocationCoordinate2D, region: MKCoordinateRegion, rect: CGRect) -> CGPoint {
        let mapPoint = MKMapPoint(coordinate)
        let mapRect = MKMapRect(region: region)
        
        let x = CGFloat((mapPoint.x - mapRect.origin.x) / mapRect.size.width) * rect.width
        let y = CGFloat((mapPoint.y - mapRect.origin.y) / mapRect.size.height) * rect.height
        
        return CGPoint(x: x, y: y)
    }
}

extension MKMapRect {
    init(region: MKCoordinateRegion) {
        let topLeft = MKMapPoint(CLLocationCoordinate2D(
            latitude: region.center.latitude + region.span.latitudeDelta / 2,
            longitude: region.center.longitude - region.span.longitudeDelta / 2))
        
        let bottomRight = MKMapPoint(CLLocationCoordinate2D(
            latitude: region.center.latitude - region.span.latitudeDelta / 2,
            longitude: region.center.longitude + region.span.longitudeDelta / 2))
        
        self = MKMapRect(
            origin: MKMapPoint(x: min(topLeft.x, bottomRight.x), y: min(topLeft.y, bottomRight.y)),
            size: MKMapSize(width: abs(topLeft.x - bottomRight.x), height: abs(topLeft.y - bottomRight.y)))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
