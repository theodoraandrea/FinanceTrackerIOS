//
//  ListItem.swift
//  testui
//
//  Created by Theodora Andrea on 25/11/24.
//

import SwiftUI

struct ListItem: View {
    
    @State var category: TransactionCategory.RawValue = "Other"
    @State var title: String = ""
    @State var amount: Double = 50000
    @State var isExpense: Bool = true
    @State var date: String = ""
    
    var body: some View {
        ZStack {
            RoundedCorner(radius: 30)
                .stroke(Color.black.opacity(0.6), lineWidth: 0.8)
                .foregroundColor(.clear)
                .frame(height: 100)
                .padding(.horizontal, 20)

            HStack {
                if (category == TransactionCategory.other.rawValue) {
                    Text("💸")
                        .font(.system(size: 40))
                } else if (category == TransactionCategory.food.rawValue) {
                    Text("🍔")
                        .font(.system(size: 40))
                } else if (category == TransactionCategory.leisure.rawValue) {
                    Text("🎥")
                        .font(.system(size: 40))
                } else if (category == TransactionCategory.education.rawValue) {
                    Text("📚")
                        .font(.system(size: 40))
                } else if (category == TransactionCategory.transport.rawValue) {
                    Text("🚗")
                        .font(.system(size:40))
                }
                
                VStack(alignment: .leading) {
                    Text(category.capitalized)
                        .foregroundStyle(Color.black)
                        .fontWeight(.medium)
                        .font(.system(size:18))
                    if (!title.isEmpty) {
                        Text(title)
                            .font(.system(size: 18))
                            .foregroundStyle(Color.black.opacity(0.8))
                            .lineLimit(1)
                    }
                }
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        Text(date)
                            .font(.caption)
                    }
                    HStack() {
                        Spacer()
                        Text(isExpense ? "-" : "+")
                            .font(.title3)
                            .foregroundStyle(isExpense ? Color.black : Color.green)
                        Text(amount.formatted())
                            .font(.headline)
                            .foregroundStyle(isExpense ? Color.black : Color.green)
                    }
                }
                .frame(width: 130)


            }
            .frame(height: 100)
            .padding(.horizontal, 40)
        }
    }
}

struct ListItemTest: View {
    var body: some View {
        ScrollView {
            VStack {
                ListItem(category: "other", title: "asdfasdfasdfasdfasdfa ", amount: 50000000, isExpense: false)
                ListItem(category: "food")
                ListItem(category: "entertainment")
                ListItem(category: "education")
            }
        }
    }
}

#Preview {
    ListItemTest()
}
