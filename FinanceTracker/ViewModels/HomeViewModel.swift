//
//  HomeViewModel.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 12/11/24.
//

import SwiftUI
import GoogleSignIn

class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var username: String = ""
    @Published var name: String = ""
    @Published var balance: Double = 0.0
    
    @Published var transactions: [Transaction] = []

    func getUserDetail() {
        
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken") else {
            return
        }
                
        self.isLoading = true
        
        WebService().getUser(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.username = user.u_username
                    self.name = user.u_fullname
                    self.balance = user.u_balance
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.isLoading = false
            }
        }
    }
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "jsonwebtoken")
    }
    
    func getAllTransactions(date:String) {
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken") else {
            return
        }
        
        self.isLoading = true
                
        WebService().getAllTransactions(token: token, month: date) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    self.transactions = transactions.reversed()
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.isLoading = false
            }
        }
    }
    
    
}

extension Notification.Name {
    static let reloadTransactions = Notification.Name("reloadTransactions")
}

