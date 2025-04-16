//
//  CountryDetailView.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI

/// A view that displays detailed information about a selected country.
struct CountryDetailView: View {
    let country: Country
    
    // Used to dismiss the current view
    @Environment(\.dismiss) private var dismiss
    
    // Reference to the shared view model
    @EnvironmentObject var viewModel: CountryViewModel
    
    // Controls display of the delete confirmation alert
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: - Country Name & Flag
                    VStack(alignment: .center, spacing: 10) {
                        Text(country.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        // Display country flag if available
                        if let flag = country.flags?.png, let flagURL = URL(string: flag) {
                            AsyncImage(url: flagURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            } placeholder: {
                                ProgressView() // Show a spinner while loading
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    // MARK: - Capital Info
                    InfoRow(icon: ImageConstants.iconBuilding, label: TextConstants.capital, value: country.capital ?? "N/A")
                    
                    // MARK: - Region Info
                    InfoRow(icon: ImageConstants.iconGlobe, label: TextConstants.region, value: country.region ?? "N/A")
                    
                    // MARK: - Currencies Info
                    if let currencies = country.currencies, !currencies.isEmpty {
                        HStack(alignment: .top) {
                            Image(systemName: ImageConstants.iconDollar)
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width: 20, height: 20)
                                .padding(.leading, 8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(TextConstants.currencies)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                // Loop through each currency and display its name and symbol
                                ForEach(currencies, id: \.code) { currency in
                                    Text("\(currency.name) (\(currency.symbol ?? ""))")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            
            // MARK: - Remove Country Button
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label(TextConstants.removeCountry, systemImage: ImageConstants.iconTrash)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(12)
                    .padding()
            }
            .alert(TextConstants.removeCountry, isPresented: $showDeleteConfirmation, actions: {
                // Confirm delete
                Button(TextConstants.removeAlertTitleYes, role: .destructive) {
                    viewModel.removeCountry(country)
                    dismiss()
                }
                // Cancel delete
                Button(TextConstants.removeAlertTitleNo, role: .cancel) { }
            }, message: {
                // Alert message: dynamic if name is valid
                if let name = country.name as? String, !name.isEmpty {
                    Text("\(TextConstants.areYouSureYouWantToRemove) \(name)?")
                } else {
                    Text(TextConstants.areYouSureYouWantToRemoveThisCountry)
                }
            })
        }
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reusable Info Row View

/// Displays a labeled row with an icon and value (used for country details).
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
