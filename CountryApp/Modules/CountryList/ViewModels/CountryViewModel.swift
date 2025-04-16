//
//  CountryViewModel.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI
import Combine

/// ViewModel responsible for managing country data, user selections, location updates, and search functionality.
class CountryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// All countries fetched from the API or local cache.
    @Published var allCountries: [Country] = []
    
    /// User-selected countries (up to a maximum of 5).
    @Published var selectedCountries: [Country] = []
    
    /// The current text in the search bar.
    @Published var searchText: String = ""
    
    /// Manages location services to get user's country code.
    @Published var locationManager = LocationManager()
    
    // MARK: - Private Properties
    
    /// Service responsible for fetching country data from the API.
    private let service = CountryService()
    
    /// Stores Combine cancellables for managing memory and subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes the view model, sets up location observation, and loads countries.
    init() {
        observeLocationUpdates()
        Task {
            await loadCountries()
        }
    }
    
    // MARK: - Location Observation
    
    /// Observes the `currentCountryCode` from the location manager and sets the initial country if applicable.
    func observeLocationUpdates() {
        locationManager.$currentCountryCode
            .compactMap { $0 } // Ignore nil values
            .sink { [weak self] code in
                self?.setInitialCountry(code: code)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Loading
    
    /// Loads countries either from local cache or API.
    func loadCountries() async {
        // Load from cache if available
        if let cached = LocalStorageService.shared.loadCountries() {
            await MainActor.run {
                self.allCountries = cached
            }
        } else {
            // Fetch from network
            await service.fetchCountries()
            DispatchQueue.main.async {
                self.allCountries = self.service.countries
                LocalStorageService.shared.saveCountries(self.service.countries)
            }
        }
    }
    
    // MARK: - Country Selection
    
    /// Sets the initial country based on a given or default code (default: "IN").
    func setInitialCountry(code: String? = nil) {
        let countryCode = code ?? "IN"
        guard selectedCountries.isEmpty,
              let match = allCountries.first(where: { $0.alpha2Code == countryCode }) else { return }
        
        selectedCountries.append(match)
    }
    
    /// Adds a country to the selected list if it's not already added and limit (5) is not reached.
    func addCountry(_ country: Country) {
        guard selectedCountries.count < 5 else { return }
        if !selectedCountries.contains(where: { $0.name == country.name }) {
            selectedCountries.append(country)
        }
    }
    
    /// Removes a country from the selected list.
    func removeCountry(_ country: Country) {
        selectedCountries.removeAll { $0.name == country.name }
    }
    
    // MARK: - Filtering
    
    /// Returns a list of countries filtered by the search text.
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return allCountries
        } else {
            return allCountries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
