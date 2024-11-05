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
        // Validate the amount string and convert it to a Double
        guard let amountValue = Double(amount), !category.isEmpty else { return }
        
        // Create a new Expense object
        let newExpense = Expense(date: date, category: category, amount: amountValue)
        
        // Insert the new expense into the model context
        context.insert(newExpense)
        
        // Update the list view model with the new expense
        listViewModel.expenses.append(newExpense)
        
        // Reset the input fields after saving
        category = ""
        amount = ""
        date = Date()
    }
}
