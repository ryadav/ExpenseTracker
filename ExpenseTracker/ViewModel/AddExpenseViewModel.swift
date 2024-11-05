//
//  AddExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import SwiftData
import Foundation

class AddExpenseViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var amount: String = ""
    @Published var date: Date = Date()
    
    func saveExpense(to listViewModel: ExpenseListViewModel, using context: ModelContext) {
        guard let amountValue = Double(amount), !category.isEmpty else { return }
        
        let newExpense = Expense(date: date, category: category, amount: amountValue)
        context.insert(newExpense)
        listViewModel.fetchExpenses(using: context)
        
        category = ""
        amount = ""
        date = Date()
    }
}
