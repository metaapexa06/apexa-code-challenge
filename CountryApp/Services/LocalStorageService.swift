//
//  LocalStorageService.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import Foundation

class LocalStorageService {
    static let shared = LocalStorageService()
    private init() {}

    private let fileName = "countries.json"

    private var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }

    func saveCountries(_ countries: [Country]) {
        guard let url = fileURL else { return }

        do {
            let data = try JSONEncoder().encode(countries)
            try data.write(to: url)
        } catch {
            print("❌ Failed to save countries locally: \(error.localizedDescription)")
        }
    }

    func loadCountries() -> [Country]? {
        guard let url = fileURL else { return nil }

        do {
            let data = try Data(contentsOf: url)
            let countries = try JSONDecoder().decode([Country].self, from: data)
            return countries
        } catch {
            print("⚠️ Failed to load countries from disk: \(error.localizedDescription)")
            return nil
        }
    }
}
