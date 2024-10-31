//
//  ContentView.swift
//  iExpense
//
//  Created by Alvaro Orellana on 19-10-24.
//

import SwiftUI

struct ContentView: View {
    
    @State var expensesViewModel = Expenses()
    @State var showAddView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ExpenseItem.ExpenseType.allCases) { expenseType in
                    Section(expenseType.rawValue) {
                        ForEach(expensesViewModel.items.filter { $0.type == expenseType }) { expense in
                            ExpenseRowView(expense: expense)
                        }
                        .onDelete { indexSet in
                            expensesViewModel.removeItem(using: indexSet, of: expenseType)
                        }
                    }
                }
            }
            .navigationTitle("IExpense")
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    showAddView = true
                }
            }
            .sheet(isPresented: $showAddView) {
                AddView(expenses: expensesViewModel)
            }
        }
    }

}

struct ExpenseRowView: View  {
    
    let expense: ExpenseItem
    let preferedCurrrency = Locale.current.currency?.identifier ?? "USD"

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.name)
                    .font(.headline)
                Text(expense.type.rawValue)
            }
            Spacer()
            Text(expense.amount, format: .currency(code: preferedCurrrency))
        }
        .foregroundStyle(style(for: expense.amount))
    }
    
    func style(for amount: Double) -> some ShapeStyle {
        if amount < 10 {
            Color.red
        } else if amount < 100 {
            Color.blue
        } else {
            Color.green
        }
    }
    
}


#Preview {
    ContentView()
}
