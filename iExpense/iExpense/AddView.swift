//
//  AddView.swift
//  iExpense
//
//  Created by Alvaro Orellana on 20-10-24.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var type: ExpenseItem.ExpenseType = .business
    @State var amount: Double = 0
    
    let expenses: Expenses
    let preferedCurrency: String = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(ExpenseItem.ExpenseType.allCases) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                TextField("Name", value: $amount, format: .currency(code: preferedCurrency))
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add Expense")
            .toolbar {
                Button("Done") {
                    expenses.saveItem(name: self.name, type: self.type, amount: self.amount)
                    dismiss()
                }
            }
        }
    }
    
}

#Preview {
    AddView(expenses: Expenses())
}
