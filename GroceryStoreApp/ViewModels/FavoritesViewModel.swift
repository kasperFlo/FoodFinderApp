//
//  FavoritesViewModel.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-07.
//

import GooglePlaces
import CoreData

// stores favorite in memory
// this handles adding / removing favorites
// checks the status of if user liked a restaurant

@MainActor
class FavoritesViewModel: ObservableObject {
    
    // signleton instance for app-wide access to favorites
    static let shared = FavoritesViewModel()
    private let viewContext: NSManagedObjectContext
    private let placesClient: GoogleMapsInteractionService
    
    // this property is used to notify views of changes to favorites list
    @Published var favoriteStores: [GMSPlace] = []
    @Published public var localFavoritesInfo: [FavoritePlace] = []
    
    private init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        self.placesClient = GoogleMapsInteractionService.shared
        
        Task { await startUpPull() }
    }

    func startUpPull() async {
        print("Starting Pull From Core Data")
        
        let request = NSFetchRequest<FavoritePlace>(entityName: "FavoritePlace")
        do {
            localFavoritesInfo = try viewContext.fetch(request)
        } catch {
            print("Error fetching local favorites: \(error)")
            localFavoritesInfo = []
        }
        
        var tempStores: [GMSPlace] = []
        for favorite in localFavoritesInfo {
            do {
                // Fetch nearby places using stored coordinates
                let nearbyPlaces = try await placesClient.fetchNearbyStores(
                    latitude: favorite.latitude,
                    longitude: favorite.longitude,
                    range: 1
                )
                
                // Find matching place by ID
                if let matchingPlace = nearbyPlaces.first(where: { $0.placeID == favorite.placeID }) {
                    tempStores.append(matchingPlace)
                }
            } catch {
                print("Error fetching place: \(error)")
            }
        }
         self.favoriteStores = tempStores
//        printCurrentPlaces()
        print("Ending Pull From Core Data")
    }
    func pushToCore() {
        viewContext.performAndWait {
            do {
                // Clear existing Core Data entries
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePlace")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try viewContext.execute(batchDeleteRequest)
                
                // Reset context after batch delete
                try viewContext.reset()
                
                // Add each local favorite to Core Data
                for store in favoriteStores {
                    let favorite = FavoritePlace(context: viewContext)
                    favorite.placeID = store.placeID
                    favorite.latitude = store.coordinate.latitude
                    favorite.longitude = store.coordinate.longitude
                }
                
                // Check for changes before saving
                if viewContext.hasChanges {
                    try viewContext.save()
                    
                    // Refresh local array after save
                    let request = NSFetchRequest<FavoritePlace>(entityName: "FavoritePlace")
                    localFavoritesInfo = try viewContext.fetch(request)
                }
                printCurrentPlaces()
            } catch {
                // Rollback on error
                viewContext.rollback()
                print("Error saving to Core Data: \(error)")
            }
        }
    }

    // local managing functions
    func toggleFavorite(_ place: GMSPlace) {
        print("Toggling favorite for place: \(place.name ?? "unknown"), ID: \(String(describing: place.placeID))")
        if isFavorite(place) {
            removeFavorite(place) ; print("Removing from favorites")
        } else {
            addFavorite(place) ; print("Adding to favorites")
        }
        pushToCore()
    }
    func isFavorite(_ place: GMSPlace) -> Bool {
        // Check if the specific placeID exists in favorites
//        guard let placeID = place.placeID else { return false }
        return favoriteStores.contains { fStoreCurrent in
            place.placeID == fStoreCurrent.placeID
        }
    }
    func addFavorite(_ place: GMSPlace)  {
        if favoriteStores.contains(where: { $0.placeID == place.placeID }) {
            print("Place already in favorites: \(place.name ?? "unknown")")
            return
        }
        favoriteStores.append(place)
    }
    func removeFavorite(_ place: GMSPlace)  {
        favoriteStores.removeAll { $0.placeID == place.placeID }
    }
    
    // helper functions
    func printCurrentPlaces(){
        print("---- Current Resturants in GMSplace-----")
        favoriteStores.forEach { place in
            if let name = place.name, let id = place.placeID {
                print("Name: \(name), ID: \(id)")
            }
        }
        print("---- End Current Resturants in GMSplace-----")
    }
    
}

