//
//  StoreListView.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//
import SwiftUI

struct StoreListView : View {
    @StateObject private var viewModel = StoreListViewModel()
    
    
    var body: some View {
            VStack {
                switch (viewModel.isLoading, viewModel.locationError, viewModel.locationService.currentLocation) {
                    case (true , _ , _):
                        ProgressView("Fetching location...")

                    case (_ , let error? , _):
                        VStack {
                            Text("Error: \(error.localizedDescription)")
                                .foregroundColor(.red)
                            Button("Retry") {
                                viewModel.retryFetchLocation()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }

                    case (_ , _ , let location?):
                        VStack {
                            Text("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                            List(viewModel.storesIDs) { store in
                                Text(store.name)
                            }
                        }

                    case (false, nil, nil):
                        VStack {
                            Text("No location data available")
                            Button("Fetch Location") {
                                viewModel.fetchLocation()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                }
            }
        .onAppear {
            viewModel.fetchNearbyStores()
        }
    }
}
