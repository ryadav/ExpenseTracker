//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import Foundation

struct ExpenseViewModel: Identifiable {
    private let expense: Expense
    
    init(expense: Expense) {
        self.expense = expense
    }
    
    var id: UUID {
        return expense.id
    }
    
    var category: String {
        return expense.category
    }
    
    var amount: String {
        return String(format: "%.2f", expense.amount)
    }
    
    // New computed property to format the date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: expense.date)
    }
}
