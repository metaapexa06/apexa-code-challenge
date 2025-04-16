//
//  Constants.swift
//  CountryApp
//
//  Created by Apexa Meta on 16/04/25.
//

import Foundation

/// Contains the base URLs used for API requests.
struct APIURLConstants {
    /// REST Countries API endpoint to fetch all country data.
    static let countryAPIURL = "https://restcountries.com/v2/all"
}

/// Contains all static text strings used across the UI.
struct TextConstants {
    // MARK: - Navigation Titles
    static let headerTitleNavigation = "Countries"
    static let selectedCountriesHeader = "Selected Countries"
    
    // MARK: - Empty States
    static let noCountriesAreSelected = "No countries are selected"
    static let noMatchingCountriesAreFound = "No matching countries are found"
    
    // MARK: - Country Removal
    static let removeCountry = "Remove Country"
    static let removeAlertTitleYes = "Yes"
    static let removeAlertTitleNo = "No"
    static let areYouSureYouWantToRemove = "Are you sure you want to remove"
    static let areYouSureYouWantToRemoveThisCountry = "Are you sure you want to remove this country?"
    
    // MARK: - Country Info Labels
    static let capital = "Capital"
    static let region = "Region"
    
    // MARK: - Limit Alerts
    static let limitReached = "Limit Reached"
    static let OK = "OK"
    static let youCanOnlyAddUpTo5Countries = "You can only add up to 5 countries."
    
    // MARK: - Detail View Labels
    static let currencies = "Currencies"
}

/// Contains image asset names used in the app.
struct ImageConstants {
    /// Navigation header title image name (if applicable).
    static let iconCheckmark = "checkmark.circle.fill"
    static let iconCircle = "plus.circle"
    static let iconBuilding = "building.2.crop.circle"
    static let iconGlobe = "globe.europe.africa"
    static let iconDollar = "dollarsign.circle.fill"
    static let iconTrash = "trash"
    
}
