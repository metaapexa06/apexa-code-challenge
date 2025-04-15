//
//  LocationManager.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentCountryCode: String?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let code = placemarks?.first?.isoCountryCode {
                DispatchQueue.main.async {
                    self.currentCountryCode = code
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        DispatchQueue.main.async {
            self.currentCountryCode = "IN" // Default to India if permission denied
        }
    }
}
