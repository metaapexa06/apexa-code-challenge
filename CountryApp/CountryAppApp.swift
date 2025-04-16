//
//  CountryAppApp.swift
//  CountryApp
//
//  Created by Apexa Meta on 15/04/25.
//

import SwiftUI

@main
struct CountryAppApp: App {
    @StateObject private var viewModel = CountryViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
