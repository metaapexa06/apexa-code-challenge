//
//  CountryModel.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

/// Represents a country with its general and financial information.
struct Country: Codable, Identifiable {
    var id: String { name }
    let name: String
    let capital: String?
    let flags: Flags?
    let region: String?
    let currencies: [Currency]?
    let alpha2Code: String
}

/// Represents currency information used by a country.
struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String
}

/// Represents URLs for the country’s flag images.
struct Flags: Codable {
    let svg: String?
    let png: String?
}
