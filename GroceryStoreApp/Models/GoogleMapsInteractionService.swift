//
//  ICartConnectionService.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-04.
//

import Foundation
import GooglePlaces
import os

public class GoogleMapsInteractionService {
    
    private let placesClient: GMSPlacesClient
    var placeResults: [GMSPlace] = []
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "GoogleMapsInteractionService")
    
    public init() {
        self.placesClient = GMSPlacesClient.shared()
        logger.info("GoogleMapsInteractionService initialized")
    }
    
    public func fetchNearbyStores(latitude: Double, longitude: Double) async throws -> [GMSPlace] {
        return try await withCheckedThrowingContinuation { continuation in
            logger.info("Fetching nearby stores for coordinates: \(latitude), \(longitude)")
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let searchArea = GMSPlaceCircularLocationOption(coordinate, 1000)
            
            let placeProperties = [
                GMSPlaceProperty.name,
                GMSPlaceProperty.coordinate,
                GMSPlaceProperty.rating,
                GMSPlaceProperty.reviews,
                GMSPlaceProperty.priceLevel,
                GMSPlaceProperty.formattedAddress,
                GMSPlaceProperty.website,
                GMSPlaceProperty.photos,
                GMSPlaceProperty.phoneNumber
            ].map { $0.rawValue }
            
            let request = GMSPlaceSearchNearbyRequest(locationRestriction: searchArea, placeProperties: placeProperties)
            let includedTypes = ["restaurant", "cafe"]
            request.includedTypes = includedTypes
            
            logger.debug("Search request configured with \(includedTypes.count) included types")
            
            let callback: GMSPlaceSearchNearbyResultCallback = { [weak self] results, error in
                guard let self = self else {
                    self?.logger.error("Self is nil in callback")
                    continuation.resume(throwing: NSError(domain: "GoogleMapsInteractionService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Service instance deallocated"]))
                    return
                }
                
                if let error = error as? NSError{
                    print("Error Domain: \(error.domain)")
                    print("Error Code: \(error.code)")
                    print("Error Description: \(error.localizedDescription)")
                    print("Error User Info: \(error.userInfo)")
                    continuation.resume(throwing: error)
                    return
                }

                guard let results = results else {
                    print("No results found or invalid result type")
                    continuation.resume(returning: [])
                    return
                }

                print("Successfully fetched \(results.count) nearby stores")
                results.forEach { place in
                    if let name = place.name {
                        print("Restaurant name: \(name)")
                    } else {
                        print("Restaurant with unnamed location")
                    }
                }
                self.placeResults = results
                continuation.resume(returning: results)
            }
            
            placesClient.searchNearby(with: request, callback: callback)
        }
    }
}
