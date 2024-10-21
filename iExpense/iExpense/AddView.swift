//
//  AddView.swift
//  iExpense
//
//  Created by Alvaro Orellana on 20-10-24.
//

import SwiftUI

struct AddView: View {
    
    @State var name: String = ""
    @State var type: String = ""
    @State var amount: Double = 0
    let expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) { type in
                        Text(type)
                    }
                }
                TextField("Name", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.numberPad)
                
            }
            .navigationTitle("Add Expense")
            .onDisappear(perform: saveItem)
        }
    }
    
    func saveItem() {
        expenses.items.append(ExpenseItem(name: name, type: type, amount: amount))
    }
}

#Preview {
//    AddView()
}
