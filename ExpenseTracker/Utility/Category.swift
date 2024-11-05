//
//  Category.swift
//  ExpenseTracker
//
//  Created by Apple on 05/11/24.
//

import Foundation

enum Category: String, CaseIterable, Identifiable {
    case entertainment = "Entertainment"
    case food = "Food"
    case utilities = "Utilities"
    case others = "Others"
    
    var id: String { self.rawValue }
}
