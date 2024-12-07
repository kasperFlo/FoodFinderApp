//
//  ResturantDetailView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI
import GooglePlaces

struct RestaurantDetailView: View {
    var store : GMSPlace
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .ignoresSafeArea(edges: .top)
                
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(store.name ?? "Unknown Store")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 12) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", store.rating))
                            }
                            Text("•")
                            if store.priceLevel.rawValue > 0 {
                                Text(String(repeating: "$", count: Int(store.priceLevel.rawValue)))
                                    .foregroundColor(.green)
                            }
                            Text("•")
                            Text("1.2 km")
                        }
                        .foregroundColor(.gray)
                    }
                    
                    // Actions
                    HStack(spacing: 20) {
                        Button(action: {
                            if let website = store.website {
                                UIApplication.shared.open(website)
                            }
                        }) {
                            Label("Website", systemImage: "globe")
                        }
                        Button(action: {}) {
                            Label("Call", systemImage: "phone")
                        }
                        Button(action: {}) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                    .foregroundColor(.green)
                    
                    // Contact Info
                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: {
                            if let phoneNumber = store.phoneNumber?.replacingOccurrences(of: " ", with: ""),
                               let url = URL(string: "tel://\(phoneNumber)"),
                               UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            Label(
                                title: { Text(store.phoneNumber ?? "") },
                                icon: { Image(systemName: "phone") }
                            )
                            .foregroundColor(.black)
                        }
//                        } label: {
//                            Label("Phone", systemImage: "phone")
//                                .fontWeight(.medium)
//                        }
                        
                        LabeledContent {
                            if let website = store.website {
                                Link(website.absoluteString, destination: website)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .lineLimit(1)
                            }
                        } label: {
                            Label("Website", systemImage: "globe")
                                .fontWeight(.medium)
                        }
                    }
                    
                    // Hours they are open
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Hours", systemImage: "clock")
                            .font(.headline)
                        
                        Grid(alignment: .leading) {
                            if let hours = store.currentOpeningHours?.weekdayText {
                                ForEach(hours, id: \.self) { dayHours in
                                    GridRow {
                                        let components = dayHours.components(separatedBy: ": ")
                                        if components.count == 2 {
                                            Text(components[0] + ":")
                                            Text(components[1])
                                        }
                                    }
                                }
                            } else {
                                Text("Hours not available")
                            }
                        }
                        .foregroundColor(.gray)
                    }
                    
                    // Location of the resturant
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Location", systemImage: "location")
                            .font(.headline)
                        
                        HStack(spacing: 8) {
                            Text(store.formattedAddress ?? "Address not available")
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                UIPasteboard.general.string = store.formattedAddress
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                            }) {
                                Image(systemName: "doc.on.clipboard")
                                    .foregroundColor(.blue)
                                    .imageScale(.medium)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 4)
                    
                    // Reviews Section for the customer reviews
                    if let reviews = store.reviews {
                        ForEach(Array(reviews.enumerated()), id: \.offset) { _, review in
                            if let placeReview = review as? GMSPlaceReview {
                                ReviewCardView(review: placeReview)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct ReviewCard: View {
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Image(systemName: "person.circle.fill")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .foregroundColor(.gray)
//                
//                VStack(alignment: .leading) {
//                    Text("John Doe")
//                        .fontWeight(.medium)
//                    HStack {
//                        ForEach(0..<5) { _ in
//                            Image(systemName: "star.fill")
//                                .foregroundColor(.yellow)
//                        }
//                        Text("• 2 days ago")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            
//            Text("Great food and atmosphere! The service was excellent and the prices are reasonable.")
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(10)
//    }
//}

//#Preview {
//    NavigationView {
//            RestaurantDetailView()
//        }
//}
