//
//  StoreListViewModel.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//
import SwiftUI
import Combine
import CoreLocation

@MainActor
class StoreListViewModel: ObservableObject {
    @Published var storesIDs: [Item] = []
    @Published var locationService: LocationService
    @Published var locationError: Error?
    @Published var isLoading = false
    
    init(locationService: LocationService = LocationService()) {
        self.locationService = locationService
        self.locationService.startUpdatingLocation()
    }
    
    func fetchNearbyStores() {
        guard let location = locationService.currentLocation else { return }
        // Implement fetching stores using the location
        // Update storesIDs accordingly
    }
    
    func fetchLocation() {
        isLoading = true
        locationError = nil
        locationService.startUpdatingLocation()
        
        // Simulate a delay to allow time for location update
        Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
            if locationService.currentLocation == nil {
                locationError = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get location"])
            }
            isLoading = false
        }
    }
    
    func retryFetchLocation() {
        fetchLocation()
    }
    
    
}
