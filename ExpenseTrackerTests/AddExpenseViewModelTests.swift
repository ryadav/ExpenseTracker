//
//  AddExpenseViewModelTests.swift
//  ExpenseTrackerTests
//
//  Created by Apple on 07/11/24.
//

import XCTest
@testable import ExpenseTracker
import SwiftData

final class AddExpenseViewModelTests: XCTestCase {
    
    var addViewModel: AddExpenseViewModel!
    var listViewModel: ExpenseListViewModel!
    var modelContainer: ModelContainer!

    override func setUpWithError() throws {
        // Initialize the model container for testing
        modelContainer = try ModelContainer(for: Expense.self)
        
        // Initialize the view models
        addViewModel = AddExpenseViewModel()
        listViewModel = ExpenseListViewModel()
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
        addViewModel = nil
        listViewModel = nil
        modelContainer = nil
    }
    
    @MainActor
    func testSaveExpenseWithValidData() throws {
        clearContext()
        // Given
        addViewModel.category = "Transport"
        addViewModel.amount = "25.0"
        
        // When
        addViewModel.saveExpense(to: listViewModel, using: modelContainer.mainContext)
        
        // Then
        XCTAssertEqual(listViewModel.expenses.count, 1)
        XCTAssertEqual(listViewModel.expenses.first?.category, "Transport")
        XCTAssertEqual(listViewModel.expenses.first?.amount, 25.0)
    }
    
    @MainActor
    func testSaveExpenseWithInvalidData() throws {
        // Given
        addViewModel.category = ""
        addViewModel.amount = "not_a_number"
        
        // When
        addViewModel.saveExpense(to: listViewModel, using: modelContainer.mainContext)
        
        // Then
        XCTAssertEqual(listViewModel.expenses.count, 0, "Invalid data should not be saved")
    }
}
