//
//  FavoritesView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI

// this displays the favorited restaurants the user selected
// displays list of favorite restaurants
// you an still go through the restaurant details through this


struct FavoritesView: View {
    
    // stateObject to maintain the favorites data across view updating
    @StateObject var favoritesViewModel: FavoritesViewModel = FavoritesViewModel.shared

    
    var body: some View {
        ScrollView {
            
            // will display a no saved favorites if user hasnt liked any
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
                
                // if the user did like and save a restaurant then we can see the restuarants with their detailed info 
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
