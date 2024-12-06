//
//  HomeView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI


struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedRadius: Double = 5
    let radiusOptions = [1, 2, 5, 10, 20]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(spacing: 12) {
                        TextField("Search restaurants...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                     
                        HStack {
                            Image(systemName: "location.circle.fill")
                                .foregroundColor(.green)
                            
                            Picker("Radius", selection: $selectedRadius) {
                                ForEach(radiusOptions, id: \.self) { radius in
                                    Text("\(radius) km").tag(Double(radius))
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(["All", "Fast Food", "Italian", "Asian", "Mexican"], id: \.self) { category in
                                Text(category)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Restaurant List
                    VStack(spacing: 15) {
                        ForEach(0..<5) { _ in
                            RestaurantCard()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Restaurants")
        }
    }
}

#Preview {
    HomeView()
}
