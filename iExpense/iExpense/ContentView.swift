//
//  ContentView.swift
//  iExpense
//
//  Created by Alvaro Orellana on 19-10-24.
//

import SwiftUI


struct ExpenseItem: Identifiable, Codable {
    private(set) var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    
    var items: [ExpenseItem]
    
    init() {
        // Load from user defaults..
        guard
            let data = UserDefaults.standard.data(forKey: "expenses"),
            let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: data)
        else {
            items = []
            return
        }
        self.items = decoded
    }
    
    deinit {
        // Save to user defaults
        if let enconded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(enconded, forKey: "expenses")
        }
    }
    
}

struct ContentView: View {
    
    @State var expenses = Expenses()
    @State var showAddView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { expense in
                    Text("\(expense.name) \(expense.type) \(expense.amount)")
                }
                .onDelete { indexSet in
                    expenses.items.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("IExpense")
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    showAddView = true
                }
            }
            .sheet(isPresented: $showAddView) {
                AddView(expenses: expenses)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
