//
//  HomeView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//
import SwiftUI
import GooglePlaces

// This is where the overall functionality of the app occurs or the visuals atleast
// location based filter
// food type based filter

struct StoreListView: View {
    
    // this containes the restaurants from google Places API
    let stores: [GMSPlace]
    
    // this stateObject property is used to track the user's location
    @StateObject private var locationService = LocationService()
    
    // selected Distance is used to filter the distance between the distance fromt he restaurant and the users
    // the other states are used to update whats populating ot the user based off what they select
    @State private var selectedDistance: Double = 5
    @State private var showServesBeerOnly: Bool = false
    @State private var showVegetarianOnly: Bool = false
    @State private var showTakeoutOnly: Bool = false
    @State private var showBreakfastOnly: Bool = false
    @State private var showLunchOnly: Bool = false
    @State private var showDinnerOnly: Bool = false
    
    
    // returns the restaurants that are filtyered based off the users preference
    // uses the stores of type GMSPlace to populate the view
    var filteredStores: [GMSPlace] {
        stores.filter { store -> Bool in
            guard let userLocation = locationService.currentLocation else { return false }
            let storeCoordinate = store.coordinate
            let storeCLLocation = CLLocation(latitude: storeCoordinate.latitude, longitude: storeCoordinate.longitude)
            let distanceInMeters = userLocation.distance(from: storeCLLocation)
            let withinDistance = distanceInMeters <= (selectedDistance * 100)
            
            if showServesBeerOnly && !((store.servesBeer == .true)) { return false }
            if showVegetarianOnly && !((store.servesVegetarianFood == .true)) { return false }
            if showTakeoutOnly && !((store.takeout == .true)) { return false }
            if showBreakfastOnly && !((store.servesBreakfast == .true)) { return false }
            if showLunchOnly && !((store.servesLunch == .true)) { return false }
            if showDinnerOnly && !((store.servesDinner == .true)) { return false }
            
            return withinDistance
        }
    }
    
    // a way to make the buttons look better
    struct FilterButton: View {
        let title: String
        let icon: String  // SF Symbol name
        @Binding var isSelected: Bool
        
        var body: some View {
            Button(action: {
                isSelected.toggle()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.black : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
            }
        }
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Gradient Header
            HStack {
                Text("Nearby Restaurants")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
                
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .padding(.top, 8)
            
            // Distance Picker
            HStack {
                Text("Distance:")
                    .font(.system(size: 14, weight: .medium))
                Picker("Distance", selection: $selectedDistance) {
                    Text("200m").tag(2.0)
                    Text("500m").tag(5.0)
                    Text("750m").tag(7.5)
                    Text("1000m").tag(10.0)
                }
                .pickerStyle(SegmentedPickerStyle())
                .accentColor(.white)
            }
            .padding()
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = .black
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
                UISegmentedControl.appearance().backgroundColor = UIColor.systemGray6
            }
            
            // Filter Buttons based off the filters seletced by the user
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // uses the button markup made earlier and passes the specific category we are filtering by
                    FilterButton(title: "Serves Beer", icon: "mug.fill", isSelected: $showServesBeerOnly)
                    FilterButton(title: "Vegetarian", icon: "leaf.fill", isSelected: $showVegetarianOnly)
                    FilterButton(title: "Takeout", icon: "bag.fill", isSelected: $showTakeoutOnly)
                    FilterButton(title: "Breakfast", icon: "sunrise.fill", isSelected: $showBreakfastOnly)
                    FilterButton(title: "Lunch", icon: "fork.knife", isSelected: $showLunchOnly)
                    FilterButton(title: "Dinner", icon: "moon.stars.fill", isSelected: $showDinnerOnly)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            // Restaurant List using the filteres version of what the user seletcs to populate the view
            // the store object itself is passed through a navigationLink so we can get more details about the restaurant itself
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

// Add this LocationManager class, it allows the vies to have access to use the user's location for diatnce calculations and allow us to do filtering neabry restaurants
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
