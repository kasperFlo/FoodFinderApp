//
//  FavoritesView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var favoritesViewModel: FavoritesViewModel = FavoritesViewModel.shared

    var body: some View {
        ScrollView {
            if favoritesViewModel.favoriteStores.isEmpty {
                VStack {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                        .padding(.top, 100)
                    
                    Text("No Favorite Restaurants Yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
            } else {
                VStack(spacing: 16) {
                    ForEach(favoritesViewModel.favoriteStores, id: \.self) { store in
                        NavigationLink(destination: RestaurantDetailView(store: store)){
                            RestaurantCard(store: store)
                        }
                    }
                }
                .padding()
            }
        }
    }
}
