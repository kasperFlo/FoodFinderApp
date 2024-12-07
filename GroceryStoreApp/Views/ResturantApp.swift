//
//  ResturantApp.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI
import GooglePlaces

@main
struct ResturantApp: App {
    
    init() {
        GMSPlacesClient.provideAPIKey(Secret)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
    
}

