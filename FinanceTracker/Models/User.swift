//
//  User.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 12/11/24.
//

import Foundation

struct User: Codable {
    let u_uid: String
    let u_fullname: String
    let u_username: String
    let u_email: String
    let u_balance: Double
}

struct SignUpRequestBody: Codable {
    let username: String
    let fullname: String
    let email: String
    let newpassword: String
    let confpassword: String
    let balance: Double
}
