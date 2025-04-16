//
//  CountryService.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI

/// A service responsible for fetching country data from the API.
class CountryService: ObservableObject {
    
    /// A published list of countries retrieved from the API.
    @Published var countries: [Country] = []
    
    /// Asynchronously fetches country data from the API and updates the `countries` array.
    func fetchCountries() async {
        // Ensure the URL is valid using the constant from APIURLConstants
        guard let url = URL(string: APIURLConstants.countryAPIURL) else { return }
        
        do {
            // Make an asynchronous network call to fetch country data
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the fetched JSON data into an array of `Country` models
            let decoded = try JSONDecoder().decode([Country].self, from: data)
            
            // Update the published countries array on the main thread
            DispatchQueue.main.async {
                self.countries = decoded
            }
        } catch {
            // Handle errors silently (could be enhanced with logging or error state)
        }
    }
}
