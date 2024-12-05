//
//  Item.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//
import Foundation

struct Item: Codable, Identifiable {
    let id: String
    let name: String
    
    let price: Double
    let imageURL: URL?
    let description: String?
    let category: String
}
