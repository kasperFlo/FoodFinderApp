//
//  EnhancedResturant.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-07.
//
import SwiftUI
import GooglePlaces

struct RestaurantCard: View {
    let store: GMSPlace
    @ObservedObject var favoritesViewModel: FavoritesViewModel = FavoritesViewModel.shared
    @ObservedObject var placesClient: GoogleMapsInteractionService = GoogleMapsInteractionService.shared
    @State private var placeImage: Image?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Restaurant Image
            Group {
                if let image = placeImage {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        )
                }
            }
            
            // Restaurant Name and Favorite Button
            HStack {
                Text(store.name ?? "Unknown Store")
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: {
                    favoritesViewModel.toggleFavorite(store)
                }) {
                    Image(systemName: favoritesViewModel.isFavorite(store) ? "heart.fill" : "heart")
                        .foregroundColor(favoritesViewModel.isFavorite(store) ? .red : .gray)
                        .font(.system(size: 24))
                }
            }
            
            // Address
            if let address = store.formattedAddress {
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            // Rating and Details
            HStack(spacing: 12) {
                // Rating
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", store.rating))
                        .fontWeight(.medium)
                }
                
                // Price Level
                if store.priceLevel.rawValue > 0 {
                    Text(String(repeating: "$", count: Int(store.priceLevel.rawValue)))
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
                
                // Phone Number
                if let phoneNumber = store.phoneNumber {
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                        Text(phoneNumber)
                    }
                    .foregroundColor(.blue)
                }
            }
            .font(.subheadline)
            
            // Website
            if let website = store.website {
                Text(website.absoluteString)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 8,
                    x: 0,
                    y: 2
                )
        )
        .onAppear {
            placesClient.loadPlacePhoto(from: store) { uiImage in
                if let uiImage = uiImage {
                    DispatchQueue.main.async {
                        self.placeImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
}
