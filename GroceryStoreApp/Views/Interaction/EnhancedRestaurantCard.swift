//
//  EnhancedResturant.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-07.
//
import SwiftUI
import GooglePlaces

struct EnhancedRestaurantCard: View {
    let store: GMSPlace
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        VStack(alignment: .leading) {
            
            if let iconURL = store.iconImageURL {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 100)
                        .cornerRadius(10)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 100)
                        .cornerRadius(10)
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading) {
                // Image section remains the same
                
                HStack {
                    Text(store.name ?? "Unknown Store")
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: {
                                    favoritesManager.toggleFavorite(store)
                                }) {
                                    Image(systemName: favoritesManager.isFavorite(store) ? "heart.fill" : "heart")
                                        .foregroundColor(favoritesManager.isFavorite(store) ? .red : .gray)
                                        .font(.system(size: 30))
                                }
                }
                .padding(.horizontal)
            }
            .padding()
            if let address = store.formattedAddress {
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", store.rating))
                
                Text("•")
                
                if store.priceLevel.rawValue > 0 {
                    Text(String(repeating: "$", count: Int(store.priceLevel.rawValue)))
                        .foregroundColor(.green)
                }
                
                if let phoneNumber = store.phoneNumber {
                    Text("•")
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(phoneNumber)
                    }
                    .foregroundColor(.blue)
                }
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            if let website = store.website {
                Text(website.absoluteString)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
}
