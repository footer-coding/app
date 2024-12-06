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

struct Checkpoint {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct Tank {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    let amount: Int
}

struct Soldier {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    let amount: Int
}

struct Plane {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    let amount: Int
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
    
    var body: some View {
        VStack {
            MapViewRepresentable(region: $region, checkpoints: $checkpoints, tanks: $tanks, soldiers: $soldiers, planes: $planes)
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
                HStack {
                    Button(action: {
                        zoomIn()
                    }) {
                        Text("Zoom In")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        zoomOut()
                    }) {
                        Text("Zoom Out")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        drawRoute.toggle()
                    }) {
                        Text(drawRoute ? "Hide Route" : "Draw Route")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                HStack {
                    Button(action: {
                        addingTanks = true
                        addingSoldiers = false
                        addingPlanes = false
                        addingCheckpoints = false
                    }) {
                        Text("Add Tanks")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        addingTanks = false
                        addingSoldiers = true
                        addingPlanes = false
                        addingCheckpoints = false
                    }) {
                        Text("Add Soldiers")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        addingTanks = false
                        addingSoldiers = false
                        addingPlanes = true
                        addingCheckpoints = false
                    }) {
                        Text("Add Planes")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        addingTanks = false
                        addingSoldiers = false
                        addingPlanes = false
                        addingCheckpoints = true
                    }) {
                        Text("Add Checkpoints")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        reset()
                    }) {
                        Text("Reset")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                HStack {
                    Text("Amount:")
                    TextField("Amount", value: $amount, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .padding()
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
    
    private func zoomIn() {
        var span = region.span
        span.latitudeDelta /= 2
        span.longitudeDelta /= 2
        region.span = span
    }
    
    private func zoomOut() {
        var span = region.span
        span.latitudeDelta *= 2
        span.longitudeDelta *= 2
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
    }
}

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var checkpoints: [Checkpoint]
    @Binding var tanks: [Tank]
    @Binding var soldiers: [Soldier]
    @Binding var planes: [Plane]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = checkpoints.map { checkpoint -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = checkpoint.coordinate
            annotation.title = "Checkpoint"
            return annotation
        } + tanks.map { tank -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = tank.coordinate
            annotation.title = "Tank (\(tank.amount))"
            return annotation
        } + soldiers.map { soldier -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = soldier.coordinate
            annotation.title = "Soldier (\(soldier.amount))"
            return annotation
        } + planes.map { plane -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = plane.coordinate
            annotation.title = "Plane (\(plane.amount))"
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "MapItem"
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.isDraggable = true
            }
            return view
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            guard let annotation = view.annotation else { return }
            switch newState {
            case .ending, .canceling:
                view.dragState = .none
                if let index = parent.checkpoints.firstIndex(where: { $0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == annotation.coordinate.longitude }) {
                    parent.checkpoints[index].coordinate = annotation.coordinate
                } else if let index = parent.tanks.firstIndex(where: { $0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == annotation.coordinate.longitude }) {
                    parent.tanks[index].coordinate = annotation.coordinate
                } else if let index = parent.soldiers.firstIndex(where: { $0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == annotation.coordinate.longitude }) {
                    parent.soldiers[index].coordinate = annotation.coordinate
                } else if let index = parent.planes.firstIndex(where: { $0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == annotation.coordinate.longitude }) {
                    parent.planes[index].coordinate = annotation.coordinate
                }
            default:
                break
            }
        }
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
