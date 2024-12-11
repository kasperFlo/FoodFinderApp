//
//  ICartConnectionService.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-04.
//

import Foundation
import GooglePlaces
import os
import SwiftUI


// Service class to handle interactions with Google Maps Places API
public class GoogleMapsInteractionService : ObservableObject{
    
    // Singleton instance for global access
    static let shared = GoogleMapsInteractionService()
    
    // Private properties for Places client and results storage
    private let placesClient: GMSPlacesClient
    var placeResults: [GMSPlace] = []
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "GoogleMapsInteractionService")
    
    // Initialize the service with shared Places client
    public init() {
        self.placesClient = GMSPlacesClient.shared()
//        logger.info("GoogleMapsInteractionService initialized")
    }
    
    
    // Fetch nearby stores within 1000m radius of given coordinates
    public func fetchNearbyStores(latitude: Double, longitude: Double, range : Double = 5) async throws -> [GMSPlace] {
        return try await withCheckedThrowingContinuation { continuation in
//            logger.info("Fetching nearby stores for coordinates: \(latitude), \(longitude)")
            
            // Set up search area with 1km radius
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let searchArea = GMSPlaceCircularLocationOption(coordinate, range)
            
            // Define place properties to fetch
            let placeProperties = [
                GMSPlaceProperty.name,
                GMSPlaceProperty.coordinate,
                GMSPlaceProperty.rating,
                GMSPlaceProperty.reviews,
                GMSPlaceProperty.priceLevel,
                GMSPlaceProperty.formattedAddress,
                GMSPlaceProperty.website,
                GMSPlaceProperty.photos,
                GMSPlaceProperty.iconImageURL,
                GMSPlaceProperty.phoneNumber,
                
                GMSPlaceProperty.openingHours,
                GMSPlaceProperty.currentOpeningHours,
                GMSPlaceProperty.servesBeer,
                GMSPlaceProperty.servesVegetarianFood,
                GMSPlaceProperty.takeout,
                GMSPlaceProperty.servesBreakfast,
                GMSPlaceProperty.servesLunch,
                GMSPlaceProperty.servesDinner
            ].map { $0.rawValue }
            
            // Configure search request, setting it up 
            let request = GMSPlaceSearchNearbyRequest(locationRestriction: searchArea, placeProperties: placeProperties)
            let includedTypes = ["restaurant", "cafe"]
            request.includedTypes = includedTypes
            
//            logger.debug("Search request configured with \(includedTypes.count) included types")
            
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
                
                
                // testing given data
                
//                results.forEach { place in
//                    if let photos = place.photos {
//                        photos.forEach { photoMetadata in
//                            if let attributions = photoMetadata.attributions {
//                                print("Photo attributions: \(attributions)")
//                            }
//                        }
//                    } else {
//                        print("No photos available for this place")
//                    }
//                }
                
                self.placeResults = results
                continuation.resume(returning: results)
            }
            
            placesClient.searchNearby(with: request, callback: callback)
        }
    }

    public func loadPlacePhoto(from place: GMSPlace, completion: @escaping (UIImage?) -> Void) {
        
        guard let photos = place.photos, let firstPhoto = photos.first else {
            completion(nil)
            return
        }
        
        let fetchPhotoRequest = GMSFetchPhotoRequest(
            photoMetadata: firstPhoto,
            maxSize: CGSize(width: 300, height: 300)
        )
        
        self.placesClient.fetchPhoto(with: fetchPhotoRequest) { image, error in
            if let error = error {
                print("Error loading photo: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(image)
        }
    }

    
}
