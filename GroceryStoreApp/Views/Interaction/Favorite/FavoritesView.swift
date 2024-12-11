//
//  FavoritesView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var favoritesViewModel: FavoritesViewModel = FavoritesViewModel.shared

    // TODO add top bar here or something add some ui flair / consistancy throughout the entire application
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(favoritesViewModel.favoriteStores, id: \.self) { store in
                    NavigationLink(destination: RestaurantDetailView(store: store)){
                        RestaurantCard(store: store)
                    }
                }
                .padding()
            }
        }
    }
}
