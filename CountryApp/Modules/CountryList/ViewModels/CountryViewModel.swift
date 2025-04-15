//
//  CountryViewModel.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI
import Combine

class CountryViewModel: ObservableObject {
    @Published var allCountries: [Country] = []
    @Published var selectedCountries: [Country] = []
    @Published var searchText: String = ""

    private let service = CountryService()
    private let locationManager = LocationManager()

    init() {
        Task {
            await loadCountries()
        }
    }
    
    func loadCountries() async {
        // Check for local data first
        if let cached = LocalStorageService.shared.loadCountries() {
            await MainActor.run {
                self.allCountries = cached
                self.setInitialCountry()
            }
        } else {
            // Fetch from API if not cached
            await service.fetchCountries()
            
            DispatchQueue.main.async {
                self.allCountries = self.service.countries
                self.setInitialCountry()
                LocalStorageService.shared.saveCountries(self.service.countries)
            }
        }
    }

    func setInitialCountry() {
        if let code = locationManager.currentCountryCode,
           let country = allCountries.first(where: { $0.alpha2Code == code }) {
            self.selectedCountries.append(country)
        } else if let defaultCountry = allCountries.first(where: { $0.alpha2Code == "IN" }) {
            self.selectedCountries.append(defaultCountry)
        }
    }

    func setInitialCountry(code: String? = nil) {
        let countryCode = code ?? "IN"
        if let match = allCountries.first(where: { $0.alpha2Code == countryCode }) {
            selectedCountries.append(match)
        }
    }
    
    func addCountry(_ country: Country) {
        guard selectedCountries.count < 5 else { return }
        if !selectedCountries.contains(where: { $0.name == country.name }) {
            selectedCountries.append(country)
        }
    }

    func removeCountry(_ country: Country) {
        selectedCountries.removeAll { $0.name == country.name }
    }

    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return allCountries
        } else {
            return allCountries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
