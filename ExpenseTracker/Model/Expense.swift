//
//  Item.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import Foundation
import SwiftData

@Model
class Expense: Identifiable {
    var id: UUID
    var date: Date
    var category: String
    var amount: Double
    
    init(id: UUID = UUID(), date: Date, category: String, amount: Double) {
        self.id = id
        self.date = date
        self.category = category
        self.amount = amount
    }
}
