//
//  MainTabView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        NavigationView {
            TabView {
                HomeBody()
                    .tabItem {
                        Label("Food Spots", systemImage: "fork.knife")
                    }
                
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
            .tint(.blue)
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = .white
                
                // Configure tab bar items appearance
                let itemAppearance = UITabBarItemAppearance()
                itemAppearance.normal.iconColor = .gray
                itemAppearance.selected.iconColor = .systemBlue
                appearance.stackedLayoutAppearance = itemAppearance
                
                // Add subtle shadow
                appearance.shadowColor = .gray.withAlphaComponent(0.2)
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }

}

//#Preview {
//    MainTabView()
//}
