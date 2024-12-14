//
//  TransactionViewModel.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 17/11/24.
//

import SwiftUI

class TransactionViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var isExpense: Bool = true
    @Published var category: TransactionCategory = .other
    @Published var amount:String = "0"
    @Published var date: Date = Date()
    var item: Transaction?
    
    func getTransaction(item:Transaction) -> () {
        self.title = item.t_name
        print(item.t_type)
        self.isExpense = item.t_type == "expense" ? true : false
        switch item.t_category {
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
        
        
        self.amount = item.t_amount.formatted()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.date(from: item.t_date)!
    }
    
    func createRequestBody() -> TransactionRequestBody {
        amount.removeAll(where: {$0 == "."})
                
        return TransactionRequestBody(
            name:self.title,
            type: self.isExpense ? "expense" : "income",
            category: self.category.rawValue,
            amount: Double(amount)!,
            date: date.formatted(.iso8601.year().month().day())
        )
    }
    
    func addTransaction(completion: @escaping (Bool) -> ()) {
        guard let token = UserDefaults.standard.string(forKey: "jsonwebtoken") else {
            return
        }
                
        let body = createRequestBody()
        
        print(body)
        
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
        
        print(body)
        
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
