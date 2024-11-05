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
    
    func saveExpense(to listViewModel: ExpenseListViewModel) {
        guard let amountValue = Double(amount) else { return }
        let newExpense = Expense(date: date, category: category, amount: amountValue)
        
        // Add the new expense to the list view model's expenses
        listViewModel.expenses.append(newExpense)
    }
}
