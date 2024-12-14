//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 12/11/24.
//

import SwiftUI
import FirebaseCore

@main
struct FinanceTrackerApp: App {
    
    @StateObject private var landingViewModel = LandingViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(landingViewModel)
        }
    }
}
