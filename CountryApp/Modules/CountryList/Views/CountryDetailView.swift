//
//  CountryDetailView.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // MARK: - Country Name & Flag
                VStack(alignment: .center, spacing: 10) {
                    Text(country.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    if let flag = country.flags?.png, let flagURL = URL(string: flag) {
                        AsyncImage(url: flagURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()

                Divider()

                // MARK: - Capital
                InfoRow(icon: "building.2.crop.circle", label: "Capital", value: country.capital ?? "N/A")

                // MARK: - Region
                InfoRow(icon: "globe.europe.africa", label: "Region", value: country.region ?? "N/A")

                // MARK: - Currencies
                if let currencies = country.currencies, !currencies.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Currencies", systemImage: "dollarsign.circle.fill")
                            .font(.headline)
                            .foregroundColor(.blue)

                        ForEach(currencies, id: \.code) { currency in
                            Text("• \(currency.name) (\(currency.symbol ?? ""))")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.top)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reusable Info Row
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
        }
    }
}
