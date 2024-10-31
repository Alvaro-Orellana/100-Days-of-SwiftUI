//
//  Expenses.swift
//  iExpense
//
//  Created by Alvaro Orellana on 31-10-24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Equatable, Codable {
    
    private(set) var id = UUID()
    let name: String
    let type: ExpenseType
    let amount: Double
    
    enum ExpenseType: String, CaseIterable, Identifiable, Codable {
        case business = "Business"
        case personal = "Personal"
        case executive = "Executive"
        
        var id: Self { self }
    }
}

@Observable
class Expenses {
    
    private(set) var items: [ExpenseItem]
    
    init() {
        // Load from user defaults..
        guard
            let data = UserDefaults.standard.data(forKey: "expenses"),
            let expenseItems = try? JSONDecoder().decode([ExpenseItem].self, from: data)
        else {
            items = []
            return
        }
        items = expenseItems
    }
    
    func saveItem(name: String, type: ExpenseItem.ExpenseType, amount: Double) {
        guard !name.isEmpty else { return }
        let item = ExpenseItem(name: name, type: type, amount: amount)
        items.append(item)
    }
    
    func removeItem(using indexSet: IndexSet, of type: ExpenseItem.ExpenseType) {
        var filteredItems = items.filter { $0.type == type }
        let removedItem = filteredItems.remove(at: indexSet.first!)
        
        if let indexToRemove = items.firstIndex(where: { $0 == removedItem}) {
            items.remove(at: indexToRemove)
        }
    }
    
    deinit {
        // Save to user defaults
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "expenses")
        }
    }
    
}
