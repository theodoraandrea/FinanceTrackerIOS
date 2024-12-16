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
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var landingViewModel = LandingViewModel()
    @State private var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(landingViewModel)
                .onOpenURL { url in
                    if url.scheme == "myapp" {
                        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                        if let queryItems = components?.queryItems,
                           let token = queryItems.first(where: { $0.name == "token" })?.value {
                            print("Token received: \(token)")
                            // Handle navigation or store the token
                            let defaults = UserDefaults.standard
                            defaults.setValue(token, forKey: "jsonwebtoken")
                            landingViewModel.isAuthenticated = true
                        }
                    }
                }
        }
    }
}
