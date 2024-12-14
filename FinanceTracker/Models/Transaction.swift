//
//  Transaction.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 17/11/24.
//

import Foundation

enum TransactionType: String, CaseIterable, Identifiable {
    case income, expense
    var id: Self { self }
}

enum TransactionCategory: String, CaseIterable, Identifiable {
    case food, transport, leisure, education, other
    var id: Self { self }
}

struct Transaction: Codable, Hashable, Identifiable {
    let t_uid: String
    let t_u_uid: String
    let t_name: String
    let t_type: String
    let t_category: String
    let t_amount: Double
    let t_date: String
    let t_created_at: String
    let t_updated_at: String
    let t_is_deleted: Bool
    var id: Self { self }
}

struct TransactionRequestBody: Codable {
    let name: String?
    let type: String?
    let category: String?
    let amount: Double?
    let date: String?
}
