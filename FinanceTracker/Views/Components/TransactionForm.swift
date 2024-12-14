//
//  TransactionForm.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 17/11/24.
//

import SwiftUI

struct TransactionForm: View {
    
    @ObservedObject var viewModel: TransactionViewModel
    @Binding var show: Bool
    
    @State var amount:String = "0"
    
    @State var showKeypad:Bool = false
    
    var body: some View {
        VStack {
            if !showKeypad {
                Text("New entry")
                    .font(.system(size: 50))
                    .fontWeight(.thin)
            }
            
            ZStack {
                Capsule()
                    .frame(height: 100)
                    .foregroundColor(.gray.opacity(0.1))
                    .padding(.horizontal, 10)
             
                Text(amount)
                    .font(.system(size:50))
                    .padding(.horizontal, 25)
                
            }
            .onTapGesture {
                showKeypad.toggle()
            }
            
            
            if showKeypad {
                NumberPad(amount:$amount, showKeypad: $showKeypad)
                    .onChange(of: amount) {
                        amount = formatBalance(value: amount)
                        viewModel.amount = amount
                    }
            } else {
                VStack(spacing: 20) {
                    HStack {
                        ZStack{
                            Capsule()
                                .fill(viewModel.isExpense ? .white : .accent)
                                .stroke(viewModel.isExpense ? Color.black.opacity(0.4) : .accent, lineWidth: 1)
                                .frame(width: 150, height: 40)
                                .onTapGesture {
                                    if (viewModel.isExpense) {
                                        viewModel.isExpense.toggle()
                                    }
                                }
                            Text("Income")
                                .foregroundStyle(viewModel.isExpense ? Color.black : .white)
                        }
                        
                        ZStack{
                            Capsule()
                                .fill(viewModel.isExpense ? .accent : .white)
                                .stroke(viewModel.isExpense ? .accent : Color.black.opacity(0.4), lineWidth: 1)
                                .frame(width: 150, height: 40)
                                .onTapGesture {
                                    if (!viewModel.isExpense) {
                                        viewModel.isExpense.toggle()
                                    }
                                }
                            Text("Expense")
                                .foregroundStyle(viewModel.isExpense ? .white : Color.black)
                        }
                    }
                    
                    TextFieldWithUnderlineStyle(title: "", placeholder: "Description", textBinding: $viewModel.title, required: false)
                    
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    
                    HStack {
                        Text("Category")
                        Spacer()
                        Picker("Category", selection: $viewModel.category) {
                            ForEach(TransactionCategory.allCases) {
                                cat in
                                Text(cat.rawValue.capitalized)
                            }
                        }.pickerStyle(.menu)
                    }
                    
                    Button(action: {
                        viewModel.addTransaction() {
                            result in switch result {
                            case true:
                                print("Transaction added!")
                            case false:
                                print("An error occurred")
                            }
                            show = false
                        }
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width / 1.25)
                    .background(.accent)
                    .cornerRadius(15)
                    
                }
                .padding(.horizontal, 20)
            }
            
            


        }
        .padding()
        
    }

}

/*
#Preview {
    TransactionForm(viewModel: TransactionViewModel())
}*/
