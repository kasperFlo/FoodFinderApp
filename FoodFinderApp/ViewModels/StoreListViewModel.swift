//
//  StoreListViewModel.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//

import SwiftUI
import Combine
import CoreLocation
import GooglePlaces

// ViewModel to manage the list of nearby stores and apply filtering logic.
@MainActor
class StoreListViewModel: ObservableObject {
    static let shared = StoreListViewModel() // Singleton instance.
    
    @Published var stores: [GMSPlace] = []                // All fetched stores.
    @Published var filteredStores: [GMSPlace] = []        // Stores filtered by user preferences.
    
    @Published var locationService: LocationService       // Service for managing location updates.
    @Published var googleMapsService: GoogleMapsInteractionService // Service for interacting with Google Maps API.
    @Published var selectedLocation: Coordinate           // Current selected location.
    
    @Published var storesError: Error?                    // Error when fetching stores.
    @Published var locationError: Error?                  // Error when fetching location.
    @Published var isLoading = false                      // Indicates if data is being loaded.
    
    // Filters for the store list based on user preferences.
    @Published var selectedDistance: Double = 5 { didSet { updateFilteredList() } }
    @Published var showServesBeerOnly: Bool = false { didSet { updateFilteredList() } }
    @Published var showVegetarianOnly: Bool = false { didSet { updateFilteredList() } }
    @Published var showTakeoutOnly: Bool = false { didSet { updateFilteredList() } }
    @Published var showBreakfastOnly: Bool = false { didSet { updateFilteredList() } }
    @Published var showLunchOnly: Bool = false { didSet { updateFilteredList() } }
    @Published var showDinnerOnly: Bool = false { didSet { updateFilteredList() } }
    
    // Predefined locations for quick selection.
    var presetLocations = [
        Coordinate(longitude: 0, latitude: 0, name: "Current Location"), // Default
        Coordinate(longitude: 139.7753269, latitude: 35.7020691, name: "Tokyo"),
        Coordinate(longitude: -73.984638, latitude: 40.759211, name: "New York"),
        Coordinate(longitude: 114.158177, latitude: 22.284681, name: "Hong Kong")
    ]
    
    // Private initializer to enforce singleton pattern.
    private init(locationService: LocationService = LocationService(),
                 googleMapsService: GoogleMapsInteractionService = GoogleMapsInteractionService.shared) {
        self.locationService = locationService
        self.googleMapsService = googleMapsService
        self.selectedLocation = presetLocations[0]
        self.locationService.startUpdatingLocation()
    }
    
    // Fetch nearby stores based on the selected location.
    func fetchNearbyStores() async {
        var long = selectedLocation.longitude
        var lat = selectedLocation.latitude
        
        // Use current location if no custom location is set.
        if long == 0 && lat == 0, let currentLocation = locationService.currentLocation {
            long = currentLocation.coordinate.longitude
            lat = currentLocation.coordinate.latitude
        }
        
        isLoading = true
        do {
            // Fetch stores within a 1000-meter range.
            stores = try await googleMapsService.fetchNearbyStores(latitude: lat, longitude: long, range: 1000)
            storesError = nil
        } catch {
            storesError = error
            stores = []
        }
        isLoading = false
        
        updateFilteredList()
        printCurrentPlaces()
    }
    
    // Filter the store list based on user-selected filters and distance.
    func updateFilteredList() {
        filteredStores = stores.filter { store -> Bool in
            // Determine the reference location.
            let referenceLocation = selectedLocation.latitude == 0 && selectedLocation.longitude == 0
                ? locationService.currentLocation
                : CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
            
            guard let referenceLocation = referenceLocation else { return false }
            
            // Calculate the distance to the store.
            let storeLocation = CLLocation(latitude: store.coordinate.latitude,
                                           longitude: store.coordinate.longitude)
            let distanceInMeters = referenceLocation.distance(from: storeLocation)
            let withinDistance = distanceInMeters <= (selectedDistance * 100)
            
            // Apply filters for store attributes.
            if showServesBeerOnly && store.servesBeer != .true { return false }
            if showVegetarianOnly && store.servesVegetarianFood != .true { return false }
            if showTakeoutOnly && store.takeout != .true { return false }
            if showBreakfastOnly && store.servesBreakfast != .true { return false }
            if showLunchOnly && store.servesLunch != .true { return false }
            if showDinnerOnly && store.servesDinner != .true { return false }
            
            return withinDistance
        }
    }
    
    // Fetch the user's current location and update the ViewModel.
    func fetchLocation() {
        isLoading = true
        locationError = nil
        locationService.startUpdatingLocation()
        
        Task {
            // Simulate a delay for location fetching.
            if locationService.currentLocation == nil {
                locationError = NSError(domain: "LocationError", code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Failed to get location"])
            }
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds simulated wait.
            isLoading = false
        }
    }
    
    // Retry fetching location if it previously failed.
    func retryFetchLocation() {
        fetchLocation()
    }
    
    // Print the current filtered list of stores for debugging purposes.
    func printCurrentPlaces() {
        print("---- Current Restaurants in Filtered List ----")
        filteredStores.forEach { place in
            if let name = place.name, let id = place.placeID {
                print("Name: \(name), ID: \(id)")
            }
        }
        print("---- End Current Restaurants in Filtered List ----")
    }
}
