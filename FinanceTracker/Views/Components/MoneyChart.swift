//
//  MoneyChart.swift
//  testui
//
//  Created by Theodora Andrea on 25/11/24.
//

import SwiftUI
import Charts

struct MoneyChart: View {
    @ObservedObject var viewModel: HomeViewModel
    
    
    var expenses: [Transaction] {
        viewModel.transactions.filter( { $0.t_type == "expense"})
    }
    
    
    var categoryColors: [String: Color] = [
        "food": .blue,
        "transport": .red,
        "entertainment": .green,
        "education": .yellow,
        "leisure": .pink,
        "other": .orange
    ]
    
    var categoryData: [(category: String, total: Double, color: Color)] {
         let grouped = Dictionary(grouping: expenses, by: { $0.t_category })
         return grouped.map { (key, value) in
             let total = value.reduce(0) { $0 + $1.t_amount }
             let color = categoryColors[key] ?? .gray // Default to gray if no color is defined
             return (category: key, total: total, color: color)
         }
     }

    var body: some View {
        VStack {
            Chart {
                ForEach(categoryData, id: \.0) { item in
                    SectorMark(
                        angle: .value("Amount", item.1),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .cornerRadius(5)
                    .foregroundStyle(item.2)
                }
            }
            .frame(height: 230)
            .scaledToFit()
            HStack {
                ForEach(categoryData, id: \.0) { item in
                    VStack {
                        Circle()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(item.color)
                        Text(item.category.capitalized)
                            .font(.caption)
                    }

                }
            }
        }
        
        
         
    }
}



