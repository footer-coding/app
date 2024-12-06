import SwiftUI
import MapKit

struct DrawingMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [MKPointAnnotation]
    @Binding var overlays: [MKOverlay]

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: DrawingMapView

        init(parent: DrawingMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 2
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addAnnotations(annotations)
        mapView.addOverlays(overlays)
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.addAnnotations(annotations)
        uiView.addOverlays(overlays)
    }
}

extension DrawingMapView.Coordinator {
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let mapView = gestureRecognizer.view as? MKMapView else { return }
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        if gestureRecognizer.state == .began {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.annotations.append(annotation)
        } else if gestureRecognizer.state == .changed {
            let polyline = MKPolyline(coordinates: [parent.annotations.last!.coordinate, coordinate], count: 2)
            parent.overlays.append(polyline)
        }
    }
}



