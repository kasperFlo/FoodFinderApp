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
    @Published var favoriteStores: [GMSPlace] = []
    
    private init() {}
    
    func toggleFavorite(_ store: GMSPlace) {
        if favoriteStores.contains(store) {
            favoriteStores.removeAll { $0 == store }
        } else {
            favoriteStores.append(store)
        }
        print("This many stores saved : \(favoriteStores.count)")
    }
    
    func isFavorite(_ store: GMSPlace) -> Bool {
        return favoriteStores.contains(store)
    }
    
}
