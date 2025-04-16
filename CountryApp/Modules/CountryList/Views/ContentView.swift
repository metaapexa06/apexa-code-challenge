//
//  ContentView.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI

/// The main content view showing selected countries, search functionality, and detail navigation.
struct ContentView: View {
    @EnvironmentObject var viewModel: CountryViewModel
    
    /// Holds the country to be removed when deletion is triggered.
    @State private var countryToRemove: Country?
    
    // MARK: - Alert States
    
    /// Controls display of the remove country alert.
    @State private var showDeleteAlert = false
    
    /// Controls display of the "add limit reached" alert.
    @State private var showAddCountryAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                
                // Section title
                SectionHeader(title: TextConstants.selectedCountriesHeader)
                
                // Show list of selected countries or a placeholder text
                if !viewModel.selectedCountries.isEmpty {
                    List {
                        ForEach(viewModel.selectedCountries) { country in
                            NavigationLink(destination: CountryDetailView(country: country)) {
                                CountryRow(country: country)
                            }
                        }
                        .onDelete(perform: confirmDelete)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text(TextConstants.noCountriesAreSelected)
                        .foregroundColor(.secondary)
                        .padding(.vertical)
                }
                
                Spacer()
            }
            .navigationTitle(TextConstants.headerTitleNavigation)
        }
        
        // MARK: - Searchable Modifier
        
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        
        // MARK: - Search Suggestions
        
        .searchSuggestions {
            ForEach(viewModel.filteredCountries.enumerated().map({ $0 }), id: \.element.id) { index, country in
                CountryRow(
                    country: country,
                    showCheckmark: viewModel.selectedCountries.contains(where: { $0.id == country.id }),
                    showAddCountry: true
                )
                .searchCompletion(country.name)
                .disabled(viewModel.selectedCountries.contains(where: { $0.id == country.id }))
            }
            
            if viewModel.filteredCountries.isEmpty {
                Text(TextConstants.noMatchingCountriesAreFound)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        
        // MARK: - Add Country on Search Submit
        
        .onSubmit(of: .search) {
            if let match = viewModel.filteredCountries.first(where: {
                $0.name.lowercased() == viewModel.searchText.lowercased()
            }) {
                viewModel.searchText = ""
                
                if viewModel.selectedCountries.count >= 5 {
                    showAddCountryAlert = true
                } else {
                    showAddCountryAlert = false
                    viewModel.addCountry(match)
                    
                    // Dismiss keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        // MARK: - Alert for Country Add Limit
        .alert(TextConstants.limitReached, isPresented: $showAddCountryAlert) {
            Button(TextConstants.OK, role: .cancel) {}
        } message: {
            Text(TextConstants.youCanOnlyAddUpTo5Countries)
        }
        
        // MARK: - Alert for Country Removal
        .alert(TextConstants.removeCountry, isPresented: $showDeleteAlert, actions: {
            Button(TextConstants.removeAlertTitleYes, role: .destructive) {
                if let country = countryToRemove {
                    viewModel.removeCountry(country)
                }
            }
            Button(TextConstants.removeAlertTitleNo, role: .cancel) {
                countryToRemove = nil
            }
        }, message: {
            if let name = countryToRemove?.name {
                Text("\(TextConstants.areYouSureYouWantToRemove) \(name)?")
            }
        })
    }
    
    /// Triggers alert before deleting a selected country from the list.
    private func confirmDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            countryToRemove = viewModel.selectedCountries[index]
            showDeleteAlert = true
        }
    }
}

// MARK: - Country Row View

/// A reusable row that displays a country’s flag, name, and optional icons.
struct CountryRow: View {
    let country: Country
    var showCheckmark: Bool = false
    var showAddCountry: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Country flag image
            AsyncImage(url: URL(string: country.flags?.png ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 25)
                    .cornerRadius(4)
                    .shadow(radius: 1)
            } placeholder: {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary.opacity(0.3))
                    .frame(width: 40, height: 25)
            }
            
            // Country name
            Text(country.name)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Checkmark or plus icon
            if showCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else if showAddCountry {
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - Section Header

/// A simple reusable section header view.
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.leading)
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(CountryViewModel())
}
