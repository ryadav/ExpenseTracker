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
           // Create a FetchDescriptor for the Expense model
           let fetchDescriptor = FetchDescriptor<Expense>()
           
           // Fetch all Expense items using the descriptor
           if let fetchedExpenses = try? context.fetch(fetchDescriptor) {
               self.expenses = fetchedExpenses
           } else {
               self.expenses = []  // Set to empty if fetch fails
           }
       }
    
    func groupExpenses(by component: Calendar.Component) -> [String: [Expense]] {
        var groupedExpenses = [String: [Expense]]()
        
        for expense in expenses {
            let date = expense.date
            let formattedDate: String
            
            switch component {
            case .day:
                formattedDate = DateFormatter.dayFormatter.string(from: date)
            case .month:
                formattedDate = DateFormatter.monthFormatter.string(from: date)
            case .year:
                formattedDate = DateFormatter.yearFormatter.string(from: date)
            default:
                formattedDate = DateFormatter.dayFormatter.string(from: date)
            }
            
            if groupedExpenses[formattedDate] == nil {
                groupedExpenses[formattedDate] = []
            }
            groupedExpenses[formattedDate]?.append(expense)
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

extension DateFormatter {
    static var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    static var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    static var yearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }
}
