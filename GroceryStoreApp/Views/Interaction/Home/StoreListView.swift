//
//  HomeView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//
import SwiftUI
import GooglePlaces

// This is where the overall functionality of the app occurs or the visuals atleast
// location based filter
// food type based filter

struct StoreListView: View {
    
    // this containes the restaurants from google Places API
//    var stores: [GMSPlace]
    
    // this stateObject property is used to track the user's location
    @StateObject private var locationService = LocationService()
    @StateObject private var viewModel : StoreListViewModel = StoreListViewModel.shared
    
    // a way to make the buttons look better
    struct FilterButton: View {
        let title: String
        let icon: String  // SF Symbol name
        @Binding var isSelected: Bool
        
        var body: some View {
            Button(action: {
                isSelected.toggle()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.black : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
            }
        }
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Gradient Header
            HStack {
                Text("Nearby Restaurants : \(viewModel.selectedLocation.name) ")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
                Menu {
                     ForEach(viewModel.presetLocations, id: \.name) { location in
                         Button(action: {
                             viewModel.selectedLocation = location
                             // Trigger fetch when location changes
                             Task {
                                 await viewModel.fetchNearbyStores()
                                 // Force UI refresh
                                 await MainActor.run {
                                     viewModel.objectWillChange.send()
                                 }
                             }
                         }) {
                             Text(location.name)
                         }
                     }
                 } label: {
                     Image(systemName: "location.circle.fill")
                         .font(.system(size: 28))
                         .foregroundStyle(
                             LinearGradient(
                                 colors: [.red, .purple],
                                 startPoint: .leading,
                                 endPoint: .trailing
                             )
                         )
                 }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .padding(.top, 8)
            
            // Distance Picker
            HStack {
                Text("Distance:")
                    .font(.system(size: 14, weight: .medium))
                Picker("Distance", selection: Binding(
                    get: { viewModel.selectedDistance },
                    set: { viewModel.selectedDistance = $0 }
                )) {
                    Text("200m").tag(2.0)
                    Text("500m").tag(5.0)
                    Text("750m").tag(7.5)
                    Text("1000m").tag(10.0)
                }
                .pickerStyle(SegmentedPickerStyle())
                .accentColor(.white)
            }
            .padding()
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = .black
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
                UISegmentedControl.appearance().backgroundColor = UIColor.systemGray6
            }
            
            // Filter Buttons based off the filters seletced by the user
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                        FilterButton(title: "Serves Beer", icon: "mug.fill", isSelected: Binding(
                            get: { viewModel.showServesBeerOnly },
                            set: { viewModel.showServesBeerOnly = $0 }
                        ))
                        FilterButton(title: "Vegetarian", icon: "leaf.fill", isSelected: Binding(
                            get: { viewModel.showVegetarianOnly },
                            set: { viewModel.showVegetarianOnly = $0 }
                        ))
                        FilterButton(title: "Takeout", icon: "bag.fill", isSelected: Binding(
                            get: { viewModel.showTakeoutOnly },
                            set: { viewModel.showTakeoutOnly = $0 }
                        ))
                        FilterButton(title: "Breakfast", icon: "sunrise.fill", isSelected: Binding(
                            get: { viewModel.showBreakfastOnly },
                            set: { viewModel.showBreakfastOnly = $0 }
                        ))
                        FilterButton(title: "Lunch", icon: "fork.knife", isSelected: Binding(
                            get: { viewModel.showLunchOnly },
                            set: { viewModel.showLunchOnly = $0 }
                        ))
                        FilterButton(title: "Dinner", icon: "moon.stars.fill", isSelected: Binding(
                            get: { viewModel.showDinnerOnly },
                            set: { viewModel.showDinnerOnly = $0 }
                        ))
                    }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            // Restaurant List using the filteres version of what the user seletcs to populate the view
            // the store object itself is passed through a navigationLink so we can get more details about the restaurant itself
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.filteredStores, id: \.self) { store in
                        NavigationLink(destination: RestaurantDetailView(store: store)) {
                            RestaurantCard(store: store)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            locationService.startUpdatingLocation()
        }
        .onDisappear {
            locationService.stopUpdatingLocation()
        }
    }
}

// Add this LocationManager class, it allows the vies to have access to use the user's location for diatnce calculations and allow us to do filtering neabry restaurants
class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        // Initialize location services
    }
}


