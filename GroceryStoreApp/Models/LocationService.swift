//
//  LocationManagerService.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//

import Combine
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    // Properties
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?

// Init done like this becasue of nsobject
    override init() {
        super.init()
        setupLocationManager()
    }
    
// Set Up
    private func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // maybe add details if denied permissions
        locationManager.distanceFilter = 1000
        locationManager.startUpdatingLocation()
    }
    
// Delegate CLLocationManagerDelegate update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            currentLocation = location
        }
    }
// Delegate CLLocationManagerDelegate error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}
