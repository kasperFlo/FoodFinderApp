//
//  Store.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//

struct Store: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    
}
