//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var viewModel: AddExpenseViewModel
    @ObservedObject var listViewModel: ExpenseListViewModel
    @Environment(\.modelContext) private var modelContext
    
    private let categories = ["Entertainment", "Food", "Utilities", "Transport", "Health", "Other"]
    
    var body: some View {
        Form {
            Picker("Category", selection: $viewModel.category) {
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            TextField("Amount", text: $viewModel.amount)
                .keyboardType(.decimalPad)
            
            DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
            
            Button("Save Expense") {
                viewModel.saveExpense(to: listViewModel, using: modelContext)
            }
        }
        .navigationTitle("Add Expense")
    }
}
