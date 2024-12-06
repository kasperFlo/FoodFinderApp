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
                        Text("Restaurant Name")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 12) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("4.5 (128 reviews)")
                            }
                            Text("•")
                            Text("$$$ - Expensive")
                            Text("•")
                            Text("1.2 km")
                        }
                        .foregroundColor(.gray)
                    }
                    
                    // Actions
                    HStack(spacing: 20) {
                        Button(action: {}) {
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
                        LabeledContent {
                            Text("(555) 123-4567")
                        } label: {
                            Label("Phone", systemImage: "phone")
                                .fontWeight(.medium)
                        }
                        
                        LabeledContent {
                            Text("www.restaurant.com")
                        } label: {
                            Label("Website", systemImage: "globe")
                                .fontWeight(.medium)
                        }
                    }
                    
                    // Hours they are open
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Hours", systemImage: "clock")
                            .font(.headline)
                        
                        VStack(alignment: .leading) {
                            Text("Monday - Friday: 9:00 AM - 10:00 PM")
                            Text("Saturday: 10:00 AM - 11:00 PM")
                            Text("Sunday: 10:00 AM - 9:00 PM")
                        }
                        .foregroundColor(.gray)
                    }
                    
                    // Location of the resturant
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Location", systemImage: "location")
                            .font(.headline)
                        Text("123 Restaurant Street")
                        Text("City, State 12345")
                        Text("1.2 kilometers away")
                            .foregroundColor(.gray)
                    }
                    
                    // Reviews Section for the customer reviews
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Reviews")
                            .font(.headline)
                        
                        ForEach(1...3, id: \.self) { _ in
                            ReviewCard()
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
