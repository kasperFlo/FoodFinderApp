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
    @ObservedObject var favoritesViewModel : FavoritesViewModel = FavoritesViewModel.shared
    @ObservedObject var placesClient : GoogleMapsInteractionService = GoogleMapsInteractionService.shared
    
    @State private var placeImage: Image?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if let image = placeImage {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .cornerRadius(10)
            }  else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .cornerRadius(10)
            }
            
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text(store.name ?? "Unknown Store")
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: { favoritesViewModel.toggleFavorite(store) ; print("Clicked Fav : \(store.name!)")}) {
                        Image(systemName: favoritesViewModel.isFavorite(store) ? "heart.fill" : "heart")
                            .foregroundColor(favoritesViewModel.isFavorite(store) ? .red : .gray)
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
        .onAppear{
            placesClient.loadPlacePhoto(from : store) { uiImage in
                if let uiImage = uiImage {
                    DispatchQueue.main.async {
                        self.placeImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
}
