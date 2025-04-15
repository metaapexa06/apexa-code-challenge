//
//  CountryModel.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

struct Country: Codable, Identifiable {
    var id: String { name }
    let name: String
    let capital: String?
    let flags: Flags?
    let region: String?
    let currencies: [Currency]?
    let alpha2Code: String
}

struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String
}

struct Flags: Codable {
    let svg: String?
    let png: String?
}
