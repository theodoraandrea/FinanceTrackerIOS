//
//  MainPageView.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 13/11/24.
//

import SwiftUI

struct Home: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var path: NavigationPath
    
    @State var showAddNew:Bool = false
    @State var showTransactionDetail:Bool = false
    @State var currentTransaction:Transaction?
    
    @State var datePointer:Int = 0
    
    func getDisplayedMonth(counter:Int) -> Date {
        let today = Date()
        let displayedDate = Calendar.current.date(byAdding: .month, value: counter, to: today) ?? today
        return displayedDate
    }
    
    func fetchData() {
        viewModel.getUserDetail()
        viewModel.getAllTransactions(date: "\(year)-\(month)")
    }
    
    var date: Date {
        let today = Date()
        let displayedDate = Calendar.current.date(byAdding: .month, value: self.datePointer, to: today) ?? today
        return displayedDate
    }
            
    var displayMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM" // "MMMM" gives the full month name, like "November"
        return formatter.string(from: date)
    }
    
    var month: String {
        return date.formatted(.dateTime.month(.twoDigits))
    }
        
    var year: String {
        //let date = getDisplayedMonth(counter:datePointer)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        //return formatter.string(from: date)
        return date.formatted(.dateTime.year())
    }
    
    var formattedBalance: String {
         let formatter = NumberFormatter()
         formatter.numberStyle = .currency
         formatter.locale = Locale.current // Adjusts to the current locale’s currency symbol
        return formatter.string(from: NSNumber(value: viewModel.balance)) ?? ""
     }
    
    var body: some View {
        ZStack {
            //Header
            VStack {
                ZStack {
                    Color.accentColor
                    HStack {
                        Text("Welcome,")
                            .foregroundStyle(Color.white)
                            .padding(0)
                        Text(viewModel.name)
                            .foregroundStyle(Color.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                        VStack (alignment: .trailing) {
                            Text("Balance")
                                .foregroundStyle(Color.white)
                            Text(viewModel.balance.formatted())
                                .font(.title3)
                                .foregroundStyle(Color.white)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(20)
                    .padding(.top, 80)
                }
                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                Spacer()
            }.ignoresSafeArea()
                .zIndex(2)

            if showTransactionDetail {
                TransactionDetail(item: currentTransaction!, show: $showTransactionDetail)
                        .zIndex(5)
            } else {
                
                
                //Content
                ScrollView {
                    VStack (spacing: 20) {
                        HStack {
                            Button (action: {
                                datePointer -= 1
                                viewModel.getAllTransactions(date: "\(year)-\(month)")
                            }){
                                Image(systemName:"chevron.backward")
                                    .font(.title2)
                            }
                            VStack {
                                Text(displayMonth)
                                    .font(.title)
                                Text(year)
                                    .font(.headline)
                            }
                            .padding(.horizontal, 20)
                            Button (action: {
                                datePointer += 1
                                viewModel.getAllTransactions(date: "\(year)-\(month)")
                            }){
                                Image(systemName:"chevron.right")
                                    .font(.title2)
                            }
                            
                        }
                        .padding([.top, .horizontal], 20)
                        
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                                .padding()
                        } else {
                            if (viewModel.transactions.isEmpty) {
                                Text("No transactions yet.")
                                    .font(.headline)
                                    .padding(.vertical, 30)
                            } else {
                                MoneyChart(viewModel:viewModel)
                                
                                ForEach(viewModel.transactions) { item in
                                    ListItem(category: item.t_category, title: item.t_name, amount: item.t_amount,
                                             isExpense: item.t_type == "expense", date: item.t_date)
                                    .onTapGesture {
                                        showTransactionDetail = true
                                        currentTransaction = item
                                        print("current transaction: \(currentTransaction!.t_uid)")
                                    }
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    fetchData()
                }
                .padding(.top, 70)
                .zIndex(1)
                
                
                //Add Button
                VStack {
                    Spacer()
                    
                    Button (action: {
                        showAddNew.toggle()
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .foregroundColor(.accent)
                            .fontWeight(.light)
                    }.sheet(isPresented: $showAddNew) {
                        TransactionForm(viewModel: TransactionViewModel(), show: $showAddNew)
                            .presentationDetents([.fraction(0.8)])
                            .presentationDragIndicator(.visible)
                    }
                }
                .zIndex(3)
            }
        }.onAppear {
            fetchData()
        }
        .onReceive(NotificationCenter.default.publisher(for: .reloadTransactions)) { notification in
            fetchData()
        }
    }
}


