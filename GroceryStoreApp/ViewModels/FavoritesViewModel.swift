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
    @Published public var favorites: [FavoritePlace] = []
    
    
    private init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        self.placesClient = GoogleMapsInteractionService.shared
        
        fetchFavorites()
        Task { await syncFavoriteStores() }
    }
    
    private func syncFavoriteStores() async {
        var stores: [GMSPlace] = []
        
        for favorite in favorites {
            do {
                let nearbyPlaces = try await placesClient.fetchNearbyStores(
                    latitude: favorite.latitude,
                    longitude: favorite.longitude
                )
                
                if let matchingPlace = nearbyPlaces.first(where: { $0.placeID == favorite.placeID }) {
                    stores.append(matchingPlace)
                }
            } catch {
                print("Error fetching place: \(error)")
            }
        }
        
        await MainActor.run {
            self.favoriteStores = stores
        }
    }
    func fetchFavorites() {
        let request = NSFetchRequest<FavoritePlace>(entityName: "FavoritePlace")
        
        do {
            favorites = try viewContext.fetch(request)
        } catch {
            print("Error fetching favorites: \(error)")
        }
    }
    func save() {
        do {
            try viewContext.save()
            fetchFavorites()
            Task {
                await syncFavoriteStores()
            }
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func toggleFavorite(_ place: GMSPlace) {
        if isFavorite(place) {
            removeFavorite(place)
        } else {
            addFavorite(place)
        }
        
        Task { await syncFavoriteStores() }
    }
    func isFavorite(_ place: GMSPlace) -> Bool {
        return favorites.contains { $0.placeID == place.placeID }
    }
    func addFavorite(_ place: GMSPlace)  {
        let favorite = FavoritePlace(context: viewContext)
        favorite.placeID = place.placeID
        favorite.latitude = place.coordinate.latitude
        favorite.longitude = place.coordinate.longitude
        
        save()
    }
    func removeFavorite(_ place: GMSPlace)  {
        if let favorite = favorites.first(where: { $0.placeID == place.placeID }) {
            viewContext.delete(favorite)
            save()
        }
    }
    
}


