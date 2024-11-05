//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var viewModel: AddExpenseViewModel  // Use AddExpenseViewModel instead of ExpenseListViewModel
    @ObservedObject var listViewModel: ExpenseListViewModel  // Reference to listViewModel for saving
    
    var body: some View {
        Form {
            TextField("Category", text: $viewModel.category)
            TextField("Amount", text: $viewModel.amount)
                .keyboardType(.decimalPad)
            DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)

            Button("Save Expense") {
                viewModel.saveExpense(to: listViewModel)  // Save expense to the list view model
            }
        }
        .navigationTitle("Add Expense")
    }
}
