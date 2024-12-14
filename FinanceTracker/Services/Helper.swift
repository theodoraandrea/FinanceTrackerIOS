//
//  Helper.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 26/11/24.
//

import Foundation

func formatBalance(value:String) -> String {
    var formattedString = ""
    
    let cleanedValue = value.replacingOccurrences(of: ".", with: "")
    let doubleValue:NSNumber = NSDecimalNumber(string:cleanedValue)
    
    if value.count < 4 { return value }

    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .decimal

    formattedString = currencyFormatter.string(from: doubleValue) ?? ""
    return formattedString
}

func isValidEmail(email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

private let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.locale = Locale.current
    return formatter
}()

func validatePassword(_ password: String) -> Bool {
    // Regular expression for at least 8 characters, 1 uppercase letter, and 1 special character
    let regex = "^(?=.*[A-Z])(?=.*[!@#$%^&*()])[A-Za-z\\d!@#$%^&*()]{8,}$"
    
    // Use NSPredicate to evaluate the password against the regex
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", regex)
    return passwordTest.evaluate(with: password)
}
