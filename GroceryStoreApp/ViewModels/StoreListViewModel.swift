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
    @Published var locationService: LocationService
    @Published var googleMapsService: GoogleMapsInteractionService
    
    @Published var storesError: Error?
    @Published var locationError: Error?
    @Published var isLoading = false
    
    private init(locationService: LocationService = LocationService() , googleMapsService : GoogleMapsInteractionService = GoogleMapsInteractionService()) {
        self.locationService = locationService
        self.googleMapsService = googleMapsService
        
        self.locationService.startUpdatingLocation()
    }
    
    func fetchNearbyStores() async {
        guard let location = locationService.currentLocation else {
            storesError = NSError(domain: "StoreError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No location available"])
            return }
        
        isLoading = true
        do {
            stores = try await googleMapsService.fetchNearbyStores(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            storesError = nil
        } catch {
            storesError = error
            stores = []
        }
        isLoading = false
        
    }
    
    func fetchLocation() {
        isLoading = true
        locationError = nil
        locationService.startUpdatingLocation()
    
        Task {
//            try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds sum
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
