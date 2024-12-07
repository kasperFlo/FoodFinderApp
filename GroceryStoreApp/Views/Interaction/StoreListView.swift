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
                            EnhancedRestaurantCard(store: store)
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

struct EnhancedRestaurantCard: View {
    let store: GMSPlace
    @State private var isFavorite: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if let iconURL = store.iconImageURL {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 100)
                        .cornerRadius(10)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .cornerRadius(10)
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading) {
                // Image section remains the same
                
                HStack {
                    Text(store.name ?? "Unknown Store")
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                            .font(.system(size: 30))
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            if let address = store.formattedAddress {
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", store.rating))
                
                Text("•")
                
                if store.priceLevel.rawValue > 0 {
                    Text(String(repeating: "$", count: Int(store.priceLevel.rawValue)))
                        .foregroundColor(.green)
                }
                
                if let phoneNumber = store.phoneNumber {
                    Text("•")
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(phoneNumber)
                    }
                    .foregroundColor(.blue)
                }
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            if let website = store.website {
                Text(website.absoluteString)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
}
