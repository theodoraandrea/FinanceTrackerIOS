//
//  TransactionDetail.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 14/12/24.
//

import SwiftUI

struct TransactionDetail: View {
    
    var item: Transaction
    @ObservedObject var viewModel: TransactionViewModel = TransactionViewModel()
    @Binding var show: Bool
    @State var amount:String = "0"
    @State var showKeypad:Bool = false
    @State var showAlert:Bool = false
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                ZStack {
                    Text("Edit entry")
                        .font(.system(size: 40))
                        .fontWeight(.thin)
                    HStack {
                        Button (action:{
                            show = false
                        }) {
                            Image(systemName: "multiply")
                                .font(.system(size: 30))
                                .fontWeight(.light)
                        }
                        Spacer()
                        Button( action: {
                            showAlert = true
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 25))
                                .fontWeight(.light)
                        }
                    }
                }
                .padding(.horizontal, 20)
        
                
                ZStack {
                    Capsule()
                        .frame(height: 100)
                        .foregroundColor(.gray.opacity(0.1))
                        .padding(.horizontal, 10)
                    
                    Text(item.t_amount.formatted())
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
                            viewModel.updateTransaction(uid: item.t_uid) {
                                result in switch result {
                                case true:
                                    print("Transaction updated!")
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
            .onAppear{
                viewModel.getTransaction(item: item)
            }
            .alert("Delete item", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) {
                    
                }
                Button("Confirm", role: .destructive) {
                    viewModel.deleteTransaction(uid: item.t_uid) {
                        result in
                        switch result {
                        case true:
                            print("Transaction deleted")
                        case false:
                            print("Error in deleting")
                        }
                        show = false
                    }
                }
            } message: {
                Text("Would you like to delete this item?")
            }
        }
        .frame(maxHeight: 600)
    }
        

    
}

    /*
#Preview {
    TransactionDetail(item: Transaction(t_uid: "xxx", t_u_uid: "xxx", t_name: "Niki tix", t_type: "expense", t_category: "leisure", t_amount: 2000000.0, t_date: "2024-12-12", t_created_at: "x", t_updated_at: "x", t_is_deleted: false))
}*/
