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

@MainActor
class StoreListViewModel: ObservableObject {
    static let shared = StoreListViewModel()
    
    @Published var stores: [GMSPlace] = []
    @Published var filteredStores : [GMSPlace] = []
    
    @Published var locationService: LocationService
    @Published var googleMapsService: GoogleMapsInteractionService
    @Published var selectedLocation: Coordinate
    
    @Published var storesError: Error?
    @Published var locationError: Error?
    @Published var isLoading = false
    
    @Published var selectedDistance: Double = 5
    @Published var showServesBeerOnly: Bool = false
    @Published var showVegetarianOnly: Bool = false
    @Published var showTakeoutOnly: Bool = false
    @Published var showBreakfastOnly: Bool = false
    @Published var showLunchOnly: Bool = false
    @Published var showDinnerOnly: Bool = false
    
    var presetLocations = [
        Coordinate(longitude: 0, latitude: 0,name: "Current Location" ), // Toronto
        Coordinate(longitude: 139.7753269 , latitude:  35.7020691 ,name: "Tokyo" ), // Toronto
        Coordinate(longitude: -73.984638  , latitude: 40.759211 , name: "New York"),  // Ottawa
        Coordinate(longitude: 114.158177  , latitude: 22.284681 , name: "Hong Kong")  // Hong Kong
    ]
    
    private init(locationService: LocationService = LocationService() , googleMapsService : GoogleMapsInteractionService = GoogleMapsInteractionService.shared) {
        self.locationService = locationService
        self.googleMapsService = googleMapsService
        self.selectedLocation = presetLocations[0]
        
        self.locationService.startUpdatingLocation()
    }
    
    func fetchNearbyStores() async {
        
        var long = selectedLocation.longitude
        var lat = selectedLocation.latitude
        
        if (long == 0 && lat == 0) {
            if let currentLocation = locationService.currentLocation {
                long = currentLocation.coordinate.longitude
                lat = currentLocation.coordinate.latitude
            }
        }
        
        isLoading = true
        do {
            print("giving long :\(long) -- lat :\(lat)")
            stores = try await googleMapsService.fetchNearbyStores(
                latitude: lat,
                longitude: long,
                range: 1000
            )
            storesError = nil
        } catch {
            storesError = error
            stores = []
        }
        isLoading = false
        
        updateFilteredList()
        printCurrentPlaces()
    }
    
    func updateFilteredList() {
        filteredStores = stores.filter { store -> Bool in
            // Get reference location based on selected location
            let referenceLocation = selectedLocation.latitude == 0 && selectedLocation.longitude == 0
                ? locationService.currentLocation
                : CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
            
            guard let referenceLocation = referenceLocation else { return false }
            
            // Calculate distance from reference point
            let storeLocation = CLLocation(latitude: store.coordinate.latitude,
                                         longitude: store.coordinate.longitude)
            let distanceInMeters = referenceLocation.distance(from: storeLocation)
            let withinDistance = distanceInMeters <= (selectedDistance * 100)
            
            // Apply filters
            if showServesBeerOnly && store.servesBeer != .true { return false }
            if showVegetarianOnly && store.servesVegetarianFood != .true { return false }
            if showTakeoutOnly && store.takeout != .true { return false }
            if showBreakfastOnly && store.servesBreakfast != .true { return false }
            if showLunchOnly && store.servesLunch != .true { return false }
            if showDinnerOnly && store.servesDinner != .true { return false }
            
            return withinDistance
        }
    }

    
    func fetchLocation() {
        isLoading = true
        locationError = nil
        locationService.startUpdatingLocation()
    
        Task {
            if locationService.currentLocation == nil {
                locationError = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get location"])
            }
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds simulated wait
            isLoading = false
        }
    }
    
    func retryFetchLocation() {
        fetchLocation()
    }
    
    func printCurrentPlaces(){
        
        print("---- Current Resturants in FilterList-----")
        filteredStores.forEach { place in
            if let name = place.name, let id = place.placeID {
                print("Name: \(name), ID: \(id)")
            }
        }
        print("---- End Current Resturants in FilterList-----")
        
        
//        print("---- Current Resturants in GMSplace-----")
//        stores.forEach { place in
//            if let name = place.name, let id = place.placeID {
//                print("Name: \(name), ID: \(id)")
//            }
//        }
//        print("---- End Current Resturants in GMSplace-----")
    }
}
