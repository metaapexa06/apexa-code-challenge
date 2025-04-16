//
//  LocationManager.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI
import CoreLocation

/// A class that manages device location and extracts the user's current country code.
/// It uses CoreLocation to request and track the user's location and provides a fallback mechanism.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    /// The Core Location manager instance
    private let manager = CLLocationManager()
    
    /// Published property to hold the user's current country code (e.g., "US", "IN")
    @Published var currentCountryCode: String?
    
    /// Initializes the location manager and requests authorization
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    /// Called when the user's location authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // If authorized, request the current location
            manager.requestLocation()
        case .denied, .restricted:
            // If permission denied or restricted, fallback to default country code (India)
            DispatchQueue.main.async {
                self.currentCountryCode = "IN"
            }
        default:
            break
        }
    }
    
    /// Called when a new location is received
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Use geocoder to get placemark from location coordinates
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let code = placemarks?.first?.isoCountryCode {
                // Set the country code based on the reverse-geocoded placemark
                DispatchQueue.main.async {
                    self.currentCountryCode = code
                }
            }
        }
    }
    
    /// Called when the location request fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Fallback to a default country code (India) in case of failure
        DispatchQueue.main.async {
            self.currentCountryCode = "IN"
        }
    }
}
