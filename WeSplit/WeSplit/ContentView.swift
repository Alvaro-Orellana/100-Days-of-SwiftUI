//
//  ContentView.swift
//  WeSplit
//
//  Created by Alvaro Orellana on 29-08-24.
//

import SwiftUI

struct ContentView: View {
    
    @State var billAmount = 0.0
    @State var numberOfPeople = 2
    @State var tipPercentage = 0
    @FocusState var amountTextFieldIsFocused: Bool
        
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $billAmount, format: .currency(code:  Locale.current.currency?.identifier ?? "usd"))
                        .keyboardType(.decimalPad)
                        .focused($amountTextFieldIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2...99, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                }
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0...100, id: \.self) { tipPercentage in
                            Text(tipPercentage, format: .percent)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                Section("Amount per person") {
                    Text(totalPerPerson, format: .currency(code: "usd"))

                }
                Section("Total amount") {
                    Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(tipPercentage == 0 && billAmount != 0 ? .red : .black )
                }
            }
            .navigationTitle("We Split")
            .toolbar {
                if amountTextFieldIsFocused {
                    Button("Done") {
                        amountTextFieldIsFocused = false
                    }
                }
            }
        }
        
    }
    
    var total: Double {
        self.billAmount + (billAmount / 100 * Double(tipPercentage))
    }
    
    var totalPerPerson: Double {
        let tipAmount = billAmount / 100.0 * Double(tipPercentage)
        return (billAmount + tipAmount) / Double(numberOfPeople)
    }
    
}

#Preview {
    ContentView()
}
