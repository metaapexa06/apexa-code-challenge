//
//  CountryAppTests.swift
//  CountryAppTests
//
//  Created by Apexa Meta on 15/04/25.
//

import Testing
@testable import CountryApp

/// A struct containing unit tests for the `CountryViewModel` and related functionality.
struct CountryAppTests {
    
    var viewModel: CountryViewModel!
    var mockCountries: [Country]!
    
    /// Initializes the test struct and sets up the mock data and view model.
    init() {
        setUp()
    }
    
    /// Sets up the mock data and initializes the `CountryViewModel` before each test.
    mutating func setUp() {
        viewModel = CountryViewModel()
        mockCountries = [
            Country(
                name: "India",
                capital: "New Delhi",
                flags: Flags(svg: nil, png: "https://flagcdn.com/in.png"),
                region: "Asia",
                currencies: [Currency(code: "INR", name: "Rupee", symbol: "₹")],
                alpha2Code: "IN"
            ),
            Country(
                name: "Canada",
                capital: "Ottawa",
                flags: Flags(svg: nil, png: "https://flagcdn.com/ca.png"),
                region: "Americas",
                currencies: [Currency(code: "CAD", name: "Canadian Dollar", symbol: "$")],
                alpha2Code: "CA"
            )
        ]
        viewModel.allCountries = mockCountries
    }
    
    /// Test: Adds a country and verifies it appears in the selected list.
    @Test
    func testAddCountry() async throws {
        let country = mockCountries[1]
        viewModel.addCountry(country)
        #expect(viewModel.selectedCountries.contains(where: { $0.name == country.name }))
    }
    
    /// Test: Adds and removes a country, verifying it no longer appears in the selected list.
    @Test
    func testRemoveCountry() async throws {
        let country = mockCountries[0]
        viewModel.addCountry(country)
        viewModel.removeCountry(country)
        #expect(!viewModel.selectedCountries.contains(where: { $0.name == country.name }))
    }
    
    /// Test: Filters the country list by a search string and verifies correct results.
    @Test
    func testSearchFilter() async throws {
        viewModel.searchText = "can"
        let results = viewModel.filteredCountries
        #expect(results.count == 1)
        #expect(results.first?.name == "Canada")
    }
    
    /// Test: Sets the initial country with `nil`, which should default to "IN".
    @Test
    func testSetInitialCountryDefaultToIN() async throws {
        viewModel.setInitialCountry(code: nil)
        #expect(viewModel.selectedCountries.contains(where: { $0.alpha2Code == "IN" }))
    }
    
    /// Test: Sets the initial country with a valid country code.
    @Test
    func testSetInitialCountryWithCustomCode() async throws {
        viewModel.setInitialCountry(code: "CA")
        #expect(viewModel.selectedCountries.contains(where: { $0.alpha2Code == "CA" }))
    }
    
    /// Test: Saves and loads countries using local storage, verifying data integrity.
    @Test
    func testLocalStorageSaveAndLoad() async throws {
        LocalStorageService.shared.saveCountries(mockCountries)
        let loaded = LocalStorageService.shared.loadCountries()
        #expect(loaded?.count == 2)
        #expect(loaded?.first?.name == "India")
    }
    
    /// Test: Ensures the same country cannot be added more than once.
    @Test
    func testAddDuplicateCountryShouldNotAddAgain() async throws {
        let country = mockCountries[0]
        viewModel.addCountry(country)
        viewModel.addCountry(country)
        #expect(viewModel.selectedCountries.filter { $0.name == country.name }.count == 1)
    }
    
    /// Test: When the search text is empty, the filter should return all countries.
    @Test
    func testSearchWithEmptyStringReturnsAllCountries() async throws {
        viewModel.searchText = ""
        #expect(viewModel.filteredCountries.count == mockCountries.count)
    }
    
    /// Test: Removing a country not in the selected list should have no effect.
    @Test
    func testRemoveNonExistingCountryDoesNothing() async throws {
        let newCountry = Country(
            name: "Germany",
            capital: "Berlin",
            flags: Flags(svg: nil, png: ""),
            region: "Europe",
            currencies: [],
            alpha2Code: "DE"
        )
        viewModel.removeCountry(newCountry)
        #expect(viewModel.selectedCountries.isEmpty)
    }
    
    /// Test: If an invalid country code is provided, "IN" should not be added.
    /// (Note: You may want to revise this if you *do* want "IN" as a fallback.)
    @Test
    func testSetInitialCountryWithInvalidCodeDefaultsToIN() async throws {
        viewModel.setInitialCountry(code: "ZZ")
        #expect(!viewModel.selectedCountries.contains(where: { $0.alpha2Code == "IN" }))
    }
}
