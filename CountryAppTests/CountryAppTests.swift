//
//  CountryAppTests.swift
//  CountryAppTests
//
//  Created by Apexa Meta on 15/04/25.
//

import Testing
@testable import CountryApp

struct CountryAppTests {

    var viewModel: CountryViewModel!
    var mockCountries: [Country]!

    init() {
        setUp()
    }

    mutating func setUp() {
        viewModel = CountryViewModel()
        mockCountries = [
            Country(name: "India", capital: "New Delhi", flags: Flags(svg: nil, png: "https://flagcdn.com/in.png"), region: "Asia", currencies: [Currency(code: "INR", name: "Rupee", symbol: "₹")], alpha2Code: "IN"),
            Country(name: "Canada", capital: "Ottawa", flags: Flags(svg: nil, png: "https://flagcdn.com/ca.png"), region: "Americas", currencies: [Currency(code: "CAD", name: "Canadian Dollar", symbol: "$")], alpha2Code: "CA"),
        ]
        viewModel.allCountries = mockCountries
    }

    @Test
    func testAddCountry() async throws {
        let country = mockCountries[1]
        viewModel.addCountry(country)
        #expect(viewModel.selectedCountries.contains(where: { $0.name == country.name }))
    }

    @Test
    func testRemoveCountry() async throws {
        let country = mockCountries[0]
        viewModel.addCountry(country)
        viewModel.removeCountry(country)
        #expect(!viewModel.selectedCountries.contains(where: { $0.name == country.name }))
    }

    @Test
    func testSearchFilter() async throws {
        viewModel.searchText = "can"
        let results = viewModel.filteredCountries
        #expect(results.count == 1)
        #expect(results.first?.name == "Canada")
    }

    @Test
    func testSetInitialCountryDefaultToIN() async throws {
        viewModel.setInitialCountry(code: nil)
        #expect(viewModel.selectedCountries.contains(where: { $0.alpha2Code == "IN" }))
    }

    @Test
    func testSetInitialCountryWithCustomCode() async throws {
        viewModel.setInitialCountry(code: "CA")
        #expect(viewModel.selectedCountries.contains(where: { $0.alpha2Code == "CA" }))
    }

    @Test
    func testLocalStorageSaveAndLoad() async throws {
        LocalStorageService.shared.saveCountries(mockCountries)
        let loaded = LocalStorageService.shared.loadCountries()
        #expect(loaded?.count == 2)
        #expect(loaded?.first?.name == "India")
    }

    @Test
    func testAddDuplicateCountryShouldNotAddAgain() async throws {
        let country = mockCountries[0]
        viewModel.addCountry(country)
        viewModel.addCountry(country)
        #expect(viewModel.selectedCountries.filter { $0.name == country.name }.count == 1)
    }

    @Test
    func testSearchWithEmptyStringReturnsAllCountries() async throws {
        viewModel.searchText = ""
        #expect(viewModel.filteredCountries.count == mockCountries.count)
    }

    @Test
    func testRemoveNonExistingCountryDoesNothing() async throws {
        let newCountry = Country(name: "Germany", capital: "Berlin", flags: Flags(svg: nil, png: ""), region: "Europe", currencies: [], alpha2Code: "DE")
        viewModel.removeCountry(newCountry)
        #expect(viewModel.selectedCountries.isEmpty)
    }

    @Test
    func testSetInitialCountryWithInvalidCodeDefaultsToIN() async throws {
        viewModel.setInitialCountry(code: "ZZ")
        #expect(!viewModel.selectedCountries.contains(where: { $0.alpha2Code == "IN" }))
    }
}

