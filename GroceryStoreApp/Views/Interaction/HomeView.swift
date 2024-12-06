//
//  HomeView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//
import SwiftUI
import GooglePlaces

struct StoreListContent: View {
    let stores: [GMSPlace]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(stores, id: \.self) { store in
                    EnhancedRestaurantCard(store: store)
                }
            }
            .padding()
        }
    }
}

struct EnhancedRestaurantCard: View {
    let store: GMSPlace
    
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
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            Text(store.name ?? "Unknown Store")
                .font(.title3)
                .fontWeight(.bold)
            
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
