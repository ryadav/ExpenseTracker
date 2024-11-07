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
    
    var groupedData: [(value: Int, color: Color, label: String)] {
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow]
        let expensesGrouped = viewModel.groupExpenses(by: selectedGrouping)
        var data: [(value: Int, color: Color, label: String)] = []
        
        for (index, (label, expenses)) in expensesGrouped.enumerated() {
            let total = Int(expenses.reduce(0) { $0 + $1.amount })
            data.append((value: total, color: colors[index % colors.count], label: "total: \(total) in \n \(label)"))
        }
        
        return data
    }
    
    var body: some View {
        VStack {
            // Static header for Pie Chart and Summary Total
            VStack {
                Picker("Group By", selection: $selectedGrouping) {
                    Text("Day").tag(Calendar.Component.day)
                    Text("Month").tag(Calendar.Component.month)
                    Text("Year").tag(Calendar.Component.year)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Static Pie Chart View
                PieChartView(data: groupedData)
                    .frame(width: 250, height: 250)
                    .padding(.top)

                Text("Total \(groupingName(for: selectedGrouping)) Expenses: \(viewModel.calculateTotal(for: selectedGrouping), specifier: "%.f")")
                    .font(.title2)
                    .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .padding(.bottom)
            
            // Scrollable List with Static Sections
            List {
                ForEach(viewModel.groupExpenses(by: selectedGrouping).sorted(by: { $0.key > $1.key }), id: \.key) { (section, expenses) in
                    Section(header: Text(section).font(.headline).padding(.vertical)) {
                        ForEach(expenses) { expense in
                            VStack(alignment: .leading) {
                                Text(expense.category)
                                    .font(.headline)
                                Text("Amount: \(expense.amount, specifier: "%.f")")
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 5)
                            .background(Color(UIColor.systemBackground))
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
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
