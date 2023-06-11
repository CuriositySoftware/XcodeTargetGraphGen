import SwiftUI
import CoreGraphics
import MapKit
import Utility

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
        }
        .padding()
        .onAppear {
            print(Echo.run(number: 1))
        }
    }
}

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 37.334900,
            longitude: -122.009020
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.008,
            longitudeDelta: 0.008
        )
    )
    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: .pan,
            showsUserLocation: false
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
