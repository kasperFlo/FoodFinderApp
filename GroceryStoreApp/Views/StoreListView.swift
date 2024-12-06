//
//  StoreListView.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//
import SwiftUI
import GooglePlaces

struct StoreListView: View {
    @StateObject private var viewModel = StoreListViewModel()
    
    var body: some View {
        VStack {
            switch (viewModel.isLoading, viewModel.locationError, viewModel.locationService.currentLocation, viewModel.storesError) {
            case (true, _, _, _):
                ProgressView("Fetching location and stores...")
                
            case (_, let locationError?, _, _):
                ErrorView(error: locationError, retryAction: viewModel.retryFetchLocation)
                
            case (_, _, let location?, let storesError?):
                LocationView(location: location)
                ErrorView(error: storesError, retryAction: { Task { await viewModel.fetchNearbyStores() } })
                
            case (_, _, let location?, _):
                LocationView(location: location)
                StoreListContent(stores: viewModel.stores)
                
            case (false, nil, nil, _):
                NoLocationView(fetchAction: viewModel.fetchLocation)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchNearbyStores()
            }
        }
    }
}

struct LocationView: View {
    let location: CLLocation
    
    var body: some View {
        Text("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
}

struct StoreListContent: View {
    let stores: [GMSPlace]
    
    var body: some View {
        List(stores, id: \.placeID) { store in
            VStack(alignment: .leading) {
                Text(store.name ?? "Unknown Store")
                    .font(.headline)
                if let address = store.formattedAddress {
                    Text(address)
                        .font(.subheadline)
                }
            }
        }
        
    }
}

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
