//
//  CountryService.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI

class CountryService: ObservableObject {
    @Published var countries: [Country] = []

    func fetchCountries() async {
        guard let url = URL(string: "https://restcountries.com/v2/all") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Country].self, from: data)
            DispatchQueue.main.async {
                self.countries = decoded
            }
        } catch {
            print("Error fetching countries: \(error)")
        }
    }
}
