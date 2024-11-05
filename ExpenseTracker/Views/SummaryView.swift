//
//  SummaryView.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: ExpenseListViewModel
    @State private var selectedGrouping: Calendar.Component = .month
    
    var body: some View {
        VStack {
            Picker("Group By", selection: $selectedGrouping) {
                Text("Day").tag(Calendar.Component.day)
                Text("Month").tag(Calendar.Component.month)
                Text("Year").tag(Calendar.Component.year)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Text("Total \(groupingName(for: selectedGrouping)) Expenses: \(viewModel.calculateTotal(for: selectedGrouping), specifier: "%.2f")")
                .font(.title)
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
        }
        .navigationTitle("Summary")
    }
    
    private func groupingName(for component: Calendar.Component) -> String {
        switch component {
        case .day:
            return "Daily"
        case .month:
            return "Monthly"
        case .year:
            return "Yearly"
        default:
            return "Total"
        }
    }
}
