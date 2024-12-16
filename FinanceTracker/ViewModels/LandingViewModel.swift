//
//  LoginViewModel.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 12/11/24.
//

import Foundation
import SwiftUI

class LandingViewModel: ObservableObject {
    
    @Published var emailOrUsername: String
    @Published var password: String
    @Published var forgotPasswordEmail: String
    @Published var isAuthenticated: Bool
    @Published var errorMessage: String
    @Published var forgotPasswordSuccessful: Bool
    
    init() {
        self.emailOrUsername = ""
        self.password = ""
        self.forgotPasswordEmail = ""
        self.isAuthenticated = false
        self.errorMessage = ""
        self.forgotPasswordSuccessful = false
    }
    
    func login() {
        
        let defaults = UserDefaults.standard
        
        WebService().login(emailorusername: emailOrUsername, password: password) {
            result in switch result {
            case .success(let token):
                defaults.setValue(token, forKey: "jsonwebtoken")
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
                
            case .failure(let error):
                if error == AuthenticationError.invalidCredentials {
                    self.errorMessage = "Incorrect email/username or password"
                } else {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
        
    func initiateOauth() {
        WebService().startOAuth(){
            result in switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .openOAuthURL, object: url)
                }
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print(self.errorMessage)
            }
        }
    }
    
    
    func forgotPassword() {
        WebService().forgotPassword(email: self.forgotPasswordEmail) {
            result in switch result {
            case .success(let msg):
                DispatchQueue.main.async {
                    self.forgotPasswordSuccessful = true
                    print(msg)
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
        
    }

}

extension Notification.Name {
    static let openOAuthURL = Notification.Name("openOAuthURL")
}
