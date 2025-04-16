//
//  LocalStorageService.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import Foundation

/// A singleton service responsible for saving and loading country data to and from local storage.
class LocalStorageService {
    
    /// Shared singleton instance
    static let shared = LocalStorageService()
    
    /// Private initializer to prevent external instantiation
    private init() {}
    
    /// Name of the file used for storing country data locally
    private let fileName = "countries.json"
    
    /// File URL in the user's document directory
    private var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }
    
    /// Saves the given list of countries to local storage as JSON
    /// - Parameter countries: The array of `Country` objects to be saved
    func saveCountries(_ countries: [Country]) {
        guard let url = fileURL else { return }
        
        do {
            // Encode countries array to JSON data
            let data = try JSONEncoder().encode(countries)
            
            // Write data to the local file
            try data.write(to: url)
        } catch {
            // Error handling can be added here (e.g., logging)
        }
    }
    
    /// Loads the list of countries from local storage
    /// - Returns: An optional array of `Country` objects, or nil if loading fails
    func loadCountries() -> [Country]? {
        guard let url = fileURL else { return nil }
        
        do {
            // Read data from the local file
            let data = try Data(contentsOf: url)
            
            // Decode the JSON data into an array of Country objects
            let countries = try JSONDecoder().decode([Country].self, from: data)
            return countries
        } catch {
            // Return nil if decoding fails
            return nil
        }
    }
}
