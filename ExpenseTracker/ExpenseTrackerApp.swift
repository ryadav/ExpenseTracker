//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Expense.self)  // Set up model container
        }
    }
}


struct ContentView: View {
    @StateObject private var listViewModel = ExpenseListViewModel()
    @StateObject private var addExpenseViewModel = AddExpenseViewModel()

    var body: some View {
        TabView {
            ExpenseListView(viewModel: listViewModel)
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet")
                }
            
            AddExpenseView(viewModel: addExpenseViewModel, listViewModel: listViewModel)
                .tabItem {
                    Label("Add Expense", systemImage: "plus.circle")
                }
            
            SummaryView(viewModel: listViewModel)
                .tabItem {
                    Label("Summary", systemImage: "chart.pie")
                }
        }
    }
}
