//
//  FavoritesViewModel.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-07.
//
import GooglePlaces

// stores favorite in memory
// this handles adding / removing favorites
// checks the status of if user liked a restaurant

@MainActor
class FavoritesViewModel: ObservableObject {
    
    // signleton instance for app-wide access to favorites
    static let shared = FavoritesViewModel()
    
    // this property is used to notify views of changes to favorites list
    @Published var favoriteStores: [GMSPlace] = []
    
    private init() {}
    
    // this function will check if stores exists in favorites removes it if found already
    func toggleFavorite(_ store: GMSPlace) {
        if favoriteStores.contains(store) {
            favoriteStores.removeAll { $0 == store }
        } else {
            favoriteStores.append(store)
        }
        // print("This many stores saved : \(favoriteStores.count)")
    }
    
    func isFavorite(_ store: GMSPlace) -> Bool {
        return favoriteStores.contains(store)
    }
    
}


