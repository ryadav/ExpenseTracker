//
//  ExpenseListViewModel.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//
import Foundation
import SwiftData

class ExpenseListViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    
    func fetchExpenses(using context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<Expense>()
        do {
            self.expenses = try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch expenses: \(error)")
            self.expenses = []
        }
    }
    
    func groupExpenses(by component: Calendar.Component) -> [String: [Expense]] {
        var groupedExpenses = [String: [Expense]]()
        
        for expense in expenses {
            let formattedDate: String
            switch component {
            case .day:
                formattedDate = DateFormatter.dayFormatter.string(from: expense.date)
            case .month:
                formattedDate = DateFormatter.monthFormatter.string(from: expense.date)
            case .year:
                formattedDate = DateFormatter.yearFormatter.string(from: expense.date)
            default:
                formattedDate = DateFormatter.dayFormatter.string(from: expense.date)
            }
            groupedExpenses[formattedDate, default: []].append(expense)
        }
        return groupedExpenses
    }
    
    func calculateTotal(for period: Calendar.Component) -> Double {
        let calendar = Calendar.current
        let now = Date()
        return expenses.reduce(0) { total, expense in
            let isInSamePeriod: Bool
            switch period {
            case .day:
                isInSamePeriod = calendar.isDate(expense.date, inSameDayAs: now)
            case .month:
                isInSamePeriod = calendar.isDate(expense.date, equalTo: now, toGranularity: .month)
            case .year:
                isInSamePeriod = calendar.isDate(expense.date, equalTo: now, toGranularity: .year)
            default:
                isInSamePeriod = false
            }
            return isInSamePeriod ? total + expense.amount : total
        }
    }
}
