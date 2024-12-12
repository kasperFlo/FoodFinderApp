//
//  StoreListView.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.

import SwiftUI
import GooglePlaces

struct HomeBody: View {
    
    // StateObject to manage store list data and maintain state across view updates
    @StateObject private var StoreVM : StoreListViewModel = StoreListViewModel.shared
    
    
    // Main view structure for displaying store listings
    var body: some View {
            VStack {
                // Switch statement to handle different states of the view
                switch (StoreVM.isLoading, StoreVM.locationError, StoreVM.locationService.currentLocation, StoreVM.storesError) {
                    
                    // Loading state
                case (true, _, _, _):
                    ProgressView("Fetching location and stores...")
                    
                    
                    // Location error state
                case (_, let locationError?, _, _):
                    ErrorView(error: locationError, retryAction: StoreVM.retryFetchLocation)
                    
                    // Location found but stores error state
                case (_, _, let location?, let storesError?):
                    LocationView(location: location)
                    ErrorView(error: storesError, retryAction: { Task { await StoreVM.fetchNearbyStores() } })
                    
                    
                    // Success state - location found and stores available
                case (_, _, let location?, _):
                    LocationView(location: location)
                    StoreListView()
                    
                    
                    // Initial state - no location data
                case (false, nil, nil, _):
                    NoLocationView(fetchAction: StoreVM.fetchLocation)
                }
            }
            .onAppear {
                Task {
                    await StoreVM.fetchNearbyStores()
            }
        }
    }
}

struct LocationView: View {
    let location: CLLocation
    var body: some View {
            // Either remove Text entirely or replace with something more useful
            Text(".")
                .font(.headline)
                .opacity(0)
        }
}



// Error view for displaying errors with retry option
struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error: \(error.localizedDescription)")
                .foregroundColor(.red)
            Button("Retry") {
                retryAction()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

// View shown when no location data is available
struct NoLocationView: View {
    let fetchAction: () -> Void
    
    var body: some View {
        VStack {
            Text("No location data available")
            Button("Fetch Location") {
                fetchAction()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
