//
//  FavoritesViewModel.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-07.
//
import GooglePlaces

@MainActor
class FavoritesViewModel: ObservableObject {
    static let shared = FavoritesViewModel()
    
    private init() {}

    @Published var favoriteStores: [GMSPlace] = []
    
    func toggleFavorite( _ store: GMSPlace) {
        if favoriteStores.contains(store) {
            favoriteStores.removeAll { $0 == store }
        } else {
            favoriteStores.append(store)
        }
    }
    
    func isFavorite(_ store: GMSPlace) -> Bool {
        print("trying")
        return favoriteStores.contains(store)
    }
}



