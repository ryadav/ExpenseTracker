//
//  ExpenseListView.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import SwiftUI

struct ExpenseListView: View {
    @StateObject var viewModel = ExpenseListViewModel()
    @State private var selectedGrouping: Calendar.Component = .day  // Track the selected grouping
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
                
                List {
                    ForEach(viewModel.groupExpenses(by: selectedGrouping).sorted(by: { $0.key > $1.key }), id: \.key) { (section, expenses) in
                        Section(header: Text(section)) {
                            ForEach(expenses) { expense in
                                VStack(alignment: .leading) {
                                    Text(expense.category)
                                        .font(.headline)
                                    Text("Amount: \(expense.amount, specifier: "%.2f")")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Expenses")
                .onAppear {
                    viewModel.fetchExpenses(using: modelContext) 
                }
            }
        }
    }
}