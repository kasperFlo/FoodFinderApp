//
//  MainTabView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        
        // Wraps the TabView in a NavigationView for navigation capabilities
        NavigationView {
            
            // Creates a tab-based interface with two tabs
            TabView {
                
                // First tab showing the main food spots screen
                HomeBody()
                    .tabItem {
                        Label("Food Spots", systemImage: "fork.knife")
                    }
                MultiChatView()
                    .tabItem {
                        Label("ChatBot", systemImage: "bubble.left.and.bubble.right")
                    }
                // Second tab showing favorites screen
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
            .tint(.blue)
            .onAppear {
                
                // Configures how tab items look
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
