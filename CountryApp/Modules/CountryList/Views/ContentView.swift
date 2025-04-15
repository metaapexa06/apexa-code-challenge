//
//  ContentView.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CountryViewModel()

    var body: some View {
        NavigationStack {
            
            VStack(spacing: 10) {
                SectionHeader(title: "Selected Countries")
                
                // MARK: - Selected Countries Section
                if !viewModel.selectedCountries.isEmpty {
                    List {
                        ForEach(viewModel.selectedCountries) { country in
                            NavigationLink(destination: CountryDetailView(country: country)) {
                                CountryRow(country: country)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text("No countries selected")
                        .foregroundColor(.secondary)
                        .padding(.vertical)
                }
            
                
                Spacer()
            }
            .navigationTitle("Countries")
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .searchSuggestions {
            ForEach(viewModel.filteredCountries) { country in
                CountryRow(
                    country: country,
                    showCheckmark: viewModel.selectedCountries.contains(where: { $0.id == country.id }),
                    showAddCountry: true
                )
                .searchCompletion(country.name)
                .disabled(viewModel.selectedCountries.contains(where: { $0.id == country.id }))
            }
            
            if viewModel.filteredCountries.isEmpty {
                Text("No matching countries found")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .onSubmit(of: .search) {
            if let match = viewModel.filteredCountries.first(where: {
                $0.name.lowercased() == viewModel.searchText.lowercased()
            }) {
                withAnimation {
                    viewModel.addCountry(match)
                    viewModel.searchText = ""
                    UIApplication.shared.windows.first?.endEditing(true)
                }
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let country = viewModel.selectedCountries[index]
            viewModel.removeCountry(country)
        }
    }
}

// MARK: - Country Row View with Flag
struct CountryRow: View {
    let country: Country
    var showCheckmark: Bool = false
    var showAddCountry: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Flag image
            AsyncImage(url: URL(string: country.flags?.png ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 25)
                    .cornerRadius(4)
                    .shadow(radius: 1)
            } placeholder: {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 25)
            }

            // Country name
            Text(country.name)
                .font(.body)

            Spacer()

            // Optional checkmark
            if showCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else if showAddCountry{
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - Section Header
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


#Preview {
    ContentView()
}
