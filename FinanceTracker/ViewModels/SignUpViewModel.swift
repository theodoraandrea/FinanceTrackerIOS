//
//  SignUpViewModel.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 13/11/24.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var fullname: String = ""
    @Published var password: String = ""
    @Published var confPassword: String = ""
    @Published var balance: Double = 0.0
    @Published var balanceString: String = ""
    @Published var errorMessage: String = ""
        
    private func createSignUpRequestBody() -> SignUpRequestBody {
        print(balanceString)
        balanceString.removeAll(where: {$0 == "."})
        print(balanceString)
        return SignUpRequestBody(
            username: self.username,
            fullname: self.fullname,
            email: self.email,
            newpassword: self.password,
            confpassword: self.confPassword,
            balance: Double(balanceString) ?? 0
        )
    }
    
    func signup(completion: @escaping (Bool) -> Void) {
        
        let defaults = UserDefaults.standard
        let body = createSignUpRequestBody()
        print(body)
                
        WebService().signup(body: body) {
            result in switch result {
            case .success(let uid):
                defaults.setValue(uid, forKey: "uid")
                completion(true)
                
            case .failure (let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

}
