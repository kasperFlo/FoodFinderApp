//
//  HomeView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//
import SwiftUI
import GooglePlaces

struct StoreListView: View {
    let stores: [GMSPlace]
    @StateObject private var locationService = LocationService()
    
    @State private var selectedDistance: Double = 5
    
    var filteredStores: [GMSPlace] {
        stores.filter { store -> Bool in
            if let userLocation = locationService.currentLocation {
                let storeCoordinate = store.coordinate
                let storeCLLocation = CLLocation(latitude: storeCoordinate.latitude, longitude: storeCoordinate.longitude)
                let distanceInMeters = userLocation.distance(from: storeCLLocation)
                return distanceInMeters <= (selectedDistance * 100) // Convert to meters
            }
            return false
        }
    }
    
    var body: some View {
        VStack {

            HStack {
                Text("Distance:")
                Picker("Distance", selection: $selectedDistance) {
                    Text("200m").tag(2.0)
                    Text("500m").tag(5.0)
                    Text("750m").tag(7.5)
                    Text("1000m").tag(10.0)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredStores, id: \.self) { store in
                        NavigationLink(destination: RestaurantDetailView(store: store)) {
                            RestaurantCard(store: store)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            locationService.startUpdatingLocation()
        }
        .onDisappear {
            locationService.stopUpdatingLocation()
        }
    }
}

// Add this LocationManager class if you don't have one
class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        // Initialize location services
    }
}



//            if let location = locationService.currentLocation {
//                Text("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//            }
            
            // to check the distance from user to store
            
//            var body: some View {
//                VStack {
//                    if let location = locationService.currentLocation {
//                        Text("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//                        ForEach(stores, id: \.self) { store in
//                            let distance = location.distance(from: CLLocation(latitude: store.coordinate.latitude, longitude: store.coordinate.longitude)) / 1000
//                            Text("Store: \(store.name ?? "Unknown") - Distance: \(String(format: "%.2f", distance))km")
//                        }
//                    }
