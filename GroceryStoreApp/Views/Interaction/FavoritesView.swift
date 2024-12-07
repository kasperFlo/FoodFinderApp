//
//  FavoritesView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(favoritesManager.favorites, id: \.self) { store in
                    NavigationLink(destination: RestaurantDetailView(store: store)){
                        EnhancedRestaurantCard(store: store)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    FavoritesView()
}
