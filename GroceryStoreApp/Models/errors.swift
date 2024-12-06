//
//  errors.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//

public enum ResponceError : Error {
    case invalidURL
    case invalidResponse
    case networkError
    case decodingError
    case locationError
}
