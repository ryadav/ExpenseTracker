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
        // Validate the amount input
        guard let amountValue = Double(amount), !category.isEmpty else { return }
        
        // Create a new Expense instance
        let newExpense = Expense(date: date, category: category, amount: amountValue)
        
        // Insert the expense into the model context and refresh the list
        context.insert(newExpense)
        listViewModel.fetchExpenses(using: context)  // Refresh list after saving
        
        // Reset fields
        category = ""
        amount = ""
        date = Date()
    }
}
