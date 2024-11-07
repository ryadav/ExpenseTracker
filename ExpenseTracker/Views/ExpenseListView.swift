//
//  ExpenseListView.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import SwiftUI

struct ExpenseListView: View {
    @StateObject var viewModel = ExpenseListViewModel()
    @State private var selectedGrouping: Calendar.Component = .day
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Group By", selection: $selectedGrouping) {
                    Text("Day").tag(Calendar.Component.day)
                    Text("Month").tag(Calendar.Component.month)
                    Text("Year").tag(Calendar.Component.year)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .accessibilityIdentifier("GroupingPicker")
                
                List {
                    ForEach(viewModel.groupExpenses(by: selectedGrouping).sorted(by: { $0.key > $1.key }), id: \.key) { (section, expenses) in
                        Section(header: Text(section)) {
                            ForEach(expenses) { expense in
                                VStack(alignment: .leading) {
                                    Text(expense.category)
                                        .font(.headline)
                                        .accessibilityIdentifier("ExpenseCategoryText")
                                    
                                    Text("Amount: \(expense.amount, specifier: "%.f")")
                                        .font(.subheadline)
                                        .accessibilityIdentifier("ExpenseAmountText")
                                }
                            }
                            .onDelete { indexSet in
                                deleteExpense(in: expenses, at: indexSet)
                            }
                        }
                        .accessibilityIdentifier("ExpenseSection_\(section)")
                    }
                }
                .navigationTitle("Expenses")
                .accessibilityIdentifier("ExpenseList")
                .onAppear {
                    viewModel.fetchExpenses(using: modelContext)
                }
            }
        }
    }
    
    private func deleteExpense(in expenses: [Expense], at offsets: IndexSet) {
        offsets.forEach { index in
            let expenseToDelete = expenses[index]
            viewModel.deleteExpense(expenseToDelete, using: modelContext)
        }
        viewModel.fetchExpenses(using: modelContext) // Refresh the list after deletion
    }
}
