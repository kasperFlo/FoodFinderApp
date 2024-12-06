//
//  Store.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//

public struct Store: Codable {
    let name: String
    let locationCode: String
    let flags: Flags
    
    struct Flags: Codable {
        let alcohol: Bool
        let pickup: Bool
        let pickupOnly: Bool
        let longDistanceDelivery: Bool
    }
}

public struct StoresResponse: Codable {
    let stores: [Store]
    let isPartial: Bool
}
