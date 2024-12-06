//
//  ICartConnectionService.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-04.
//

import Foundation
import GooglePlaces

public class GoogleMapsInteractionService {
    
    private let placesClient: GMSPlacesClient
    var placeResults: [GMSPlace] = []
    
    public init() {
        self.placesClient = GMSPlacesClient.shared()
    }
    
    public func fetchNearbyStores(latitude: Double, longitude: Double) async throws -> [GMSPlace] {
        return try await withCheckedThrowingContinuation { continuation in
            // set up params
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let searchArea = GMSPlaceCircularLocationOption(coordinate, 1000)
            let placeProperties = [
                GMSPlaceProperty.name,
                GMSPlaceProperty.coordinate ,
                GMSPlaceProperty.rating ,
                GMSPlaceProperty.reviews ,
                GMSPlaceProperty.priceLevel ,
                GMSPlaceProperty.formattedAddress ,
                GMSPlaceProperty.website ,
                GMSPlaceProperty.photos ,
                GMSPlaceProperty.phoneNumber
            ] .map {$0.rawValue}
            
            //set up request object
            var request = GMSPlaceSearchNearbyRequest(locationRestriction: searchArea, placeProperties: placeProperties)
            let includedTypes = ["restaurant", "cafe"]
            request.includedTypes = includedTypes
            
            // Set up callback function
            let callback: GMSPlaceSearchNearbyResultCallback = { [weak self] results, error in
                guard let self else {
                    if let error {
                        print(error.localizedDescription)
                    }
                    return
                }
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let results = results as? [GMSPlace] else {
                    continuation.resume(returning: [])
                    return
                }
                
                // Store results in placeResults and resume continuation
                self.placeResults = results
                continuation.resume(returning: results) // Return the results here
            }
            
            placesClient.searchNearby(with: request, callback: callback)
        }
    }
}


