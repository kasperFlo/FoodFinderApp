//
//  EnhancedResturant.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-07.
//
import SwiftUI
import GooglePlaces

// displays the information in a nicer way for each restaurant
// restaurant details in broad spectrum

struct RestaurantCard: View {
    
    // data of restaurants from google places api
    let store: GMSPlace
    
    // this is a call for the viewmodel, it manages favorites state
    @StateObject var favoritesViewModel: FavoritesViewModel = FavoritesViewModel.shared
    
    // this handles the google places API interaction
    @ObservedObject var placesClient: GoogleMapsInteractionService = GoogleMapsInteractionService.shared
    
    // this stores and loads restaurant image
    @State private var placeImage: Image?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Restaurant Image of what the restaurant looks like
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
            
            // Name of the restaurant and the liking button so the user can save their favorite restaurant
            HStack {
                Text(store.name ?? "Unknown Store")
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                Spacer()
                
                // using the favorite viewmodel we populate with the restaurant into the view
                // theres a button to like the restaurant itself
                Button(action: {
                    favoritesViewModel.toggleFavorite(store)
                }) {
                    Image(systemName: favoritesViewModel.isFavorite(store) ? "heart.fill" : "heart")
                        .foregroundColor(favoritesViewModel.isFavorite(store) ? .red : .gray)
                        .font(.system(size: 24))
                }
            }
            
            // this will display the address of the restaurant taken from the api
            if let address = store.formattedAddress {
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            // here we display the ratings and price level for the the restaurant
            // it will show a star and the rating out of 5
            // the price level is determined by the $, so $ is cheap and $$$ is expensive
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
                
                // shows the Phone Number of the place
                if let phoneNumber = store.phoneNumber {
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                        Text(phoneNumber)
                    }
                    .foregroundColor(.blue)
                }
            }
            .font(.subheadline)
            
            // this is the Website to the place
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
            
            // ensurtes the image is loaded with the UI
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
