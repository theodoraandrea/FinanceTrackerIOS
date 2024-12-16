//
//  TransactionViewModel.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 17/11/24.
//

import SwiftUI

class TransactionViewModel: ObservableObject {
    @Published var title: String
    @Published var isExpense: Bool
    @Published var category: TransactionCategory
    @Published var categoryString: String = ""
    @Published var amount:String
    @Published var dateString:String = ""
    @Published var date: Date
    
    init(title: String, isExpense: Bool, categoryString: String, amount: String, dateString: String) {
        self.title = title
        self.isExpense = isExpense
        
        switch categoryString {
        case "food":
            self.category = .food
        case "leisure":
            self.category = .leisure
        case "education":
            self.category = .education
        case "transport":
            self.category = .transport
        default:
            self.category = .other
        }
        
        self.amount = amount
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.date(from: dateString)!
        self.date = date
    }
    
    init () {
        self.title = ""
        self.isExpense = true
        self.category = .other
        self.amount = "0"
        self.date = Date()
    }
    
    func createRequestBody() -> TransactionRequestBody {
        amount.removeAll(where: {$0 == "."})
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Specify your desired format
        formatter.timeZone = .current       // Use the current time zone
        formatter.locale = .current         // Use the current locale
        let formattedDate = formatter.string(from: self.date)
                
        return TransactionRequestBody(
            name:self.title,
            type: self.isExpense ? "expense" : "income",
            category: self.category.rawValue,
            amount: Double(amount)!,
            date: formattedDate
        )
    }
    
    func addTransaction(completion: @escaping (Bool) -> ()) {
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken") else {
            return
        }
                
        let body = createRequestBody()
                
        WebService().addTransaction(token: token, body: body) {
            result in switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .reloadTransactions, object: message)
                }
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func updateTransaction(uid:String, completion: @escaping (Bool) -> ()) {
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken") else {
            return
        }
        
        let body = createRequestBody()
                
        WebService().updateTransaction(token: token, uid: uid, body: body) {
            result in switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .reloadTransactions, object: message)
                }
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
        
    }
    
    func deleteTransaction(uid:String, completion: @escaping (Bool) -> ()) {
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken") else {
            return
        }
        
        WebService().deleteTransaction(token: token, uid: uid) {
            result in switch result {
            case .success:
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .reloadTransactions, object: "Transaction deleted")
                }
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
            
        }   
    }
}
