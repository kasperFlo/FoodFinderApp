//
//  FavoritesView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(0..<3) { _ in
                        RestaurantCard()
                    }
                }
                .padding()
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
