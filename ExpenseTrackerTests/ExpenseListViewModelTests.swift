//
//  ExpenseListViewModelTests.swift
//  ExpenseTrackerTests
//
//  Created by Apple on 07/11/24.
//

import XCTest
@testable import ExpenseTracker
import SwiftData

final class ExpenseListViewModelTests: XCTestCase {
    var viewModel: ExpenseListViewModel!
    var modelContainer: ModelContainer!
    
    override func setUpWithError() throws {
        // Initialize the model container for testing
        modelContainer = try ModelContainer(for: Expense.self)
        
        // Initialize the view model
        viewModel = ExpenseListViewModel()
    }
    
    @MainActor
    func clearContext() {
        let fetchDescriptor = FetchDescriptor<Expense>()
        if let expenses = try? modelContainer.mainContext.fetch(fetchDescriptor) {
            for expense in expenses {
                modelContainer.mainContext.delete(expense)
            }
        }
        try? modelContainer.mainContext.save()  // Save after deletion to clear everything
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        modelContainer = nil
    }
    
    @MainActor
    func testFetchExpenses() throws {
        clearContext()
        // Given
        let expense = Expense(date: Date(), category: "Food", amount: 50.0)
        modelContainer.mainContext.insert(expense)
        
        // When
        viewModel.fetchExpenses(using: modelContainer.mainContext)
        
        // Then
        XCTAssertEqual(viewModel.expenses.count, 1)
        XCTAssertEqual(viewModel.expenses.first?.category, "Food")
        XCTAssertEqual(viewModel.expenses.first?.amount, 50.0)
    }
    
    @MainActor
    func testDeleteExpense() throws {
        clearContext()
        // Given
        let expense = Expense(date: Date(), category: "Food", amount: 50.0)
        modelContainer.mainContext.insert(expense)
        try modelContainer.mainContext.save()  // Ensure the expense is saved in the context
        viewModel.fetchExpenses(using: modelContainer.mainContext)
        
        // Verify initial state
        XCTAssertEqual(viewModel.expenses.count, 1, "Initial count should be 1 after inserting an expense")
        
        // When
        viewModel.deleteExpense(expense, using: modelContainer.mainContext)
        try modelContainer.mainContext.save()  // Save the context to persist deletion
        viewModel.fetchExpenses(using: modelContainer.mainContext)  // Refresh expenses after deletion
        
        // Then
        XCTAssertEqual(viewModel.expenses.count, 0, "Count should be 0 after deleting the expense")
    }
    
    @MainActor
    func testGroupExpensesByDay() throws {
        clearContext()
        // Given
        let today = Date()
        let expense1 = Expense(date: today, category: "Food", amount: 20.0)
        let expense2 = Expense(date: today, category: "Entertainment", amount: 30.0)
        modelContainer.mainContext.insert(expense1)
        modelContainer.mainContext.insert(expense2)
        viewModel.fetchExpenses(using: modelContainer.mainContext)
        
        // When
        let grouped = viewModel.groupExpenses(by: .day)
        
        // Then
        XCTAssertEqual(grouped.count, 1)
        XCTAssertEqual(grouped[DateFormatter.dayFormatter.string(from: today)]!.count, 2)
    }
    
    @MainActor
    func testCalculateTotalForMonth() throws {
        clearContext()
        
        // Given
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let middleOfMonthDate = calendar.date(byAdding: .day, value: 15, to: startOfMonth)!
        
        let expense1 = Expense(date: startOfMonth, category: "Utilities", amount: 100.0)
        let expense2 = Expense(date: middleOfMonthDate, category: "Groceries", amount: 50.0)
        
        modelContainer.mainContext.insert(expense1)
        modelContainer.mainContext.insert(expense2)
        try modelContainer.mainContext.save()  // Ensure the expenses are saved in the context
        viewModel.fetchExpenses(using: modelContainer.mainContext)
        
        // When
        let total = viewModel.calculateTotal(for: .month)
        
        // Then
        XCTAssertEqual(total, 150.0, "Total for the month should include both expenses")
    }
}
