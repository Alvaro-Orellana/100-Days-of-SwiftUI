//
//  ContentView.swift
//  Project day 35
//
//  Created by Alvaro Orellana on 14-10-24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var multiplicationTable = 1
    @State private var numberOfQuestions: Int = 0
    let numberOfQuestionsOptions = [5, 10, 20]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Multiplication Table") {
                    Stepper("Select your multiplication table", value: $multiplicationTable, in: 2...12)
                    Text("Table of \(multiplicationTable) selected")
                        .font(.headline)
                        .padding(.leading, 30)
                }
                Section("Number of questions") {
                    Picker("Select your multiplication table", selection: $numberOfQuestions) {
                        ForEach(numberOfQuestionsOptions, id: \.self) { choice in
                            Text(choice.description)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text("\(numberOfQuestions) questions selected")
                        .multilineTextAlignment(.trailing)
                }
                NavigationLink(destination: QuizView(multiplicationTable: multiplicationTable, numberOfQuestions: numberOfQuestions)) {
                    Button("Play", action: {})
                        .buttonStyle(.borderedProminent)
                    
                }
                
                
            }
            .padding()
            .navigationTitle("Learn your tables")
        }
    }
}


#Preview {
    ContentView()
}
