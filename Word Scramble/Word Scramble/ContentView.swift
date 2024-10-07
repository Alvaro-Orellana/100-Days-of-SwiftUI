//
//  ContentView.swift
//  Word Scramble
//
//  Created by Alvaro Orellana on 02-10-24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewmodel = ViewModel()
    @State private var inputWord = ""
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        TextField("Enter your word", text: $inputWord)
                            .textInputAutocapitalization(.never)
                    }
                    Section {
                        ForEach(viewmodel.correctWords, id: \.self) { word in
                            Label(word, systemImage: "\(word.count).circle")
                        }
                    }
                }
                Spacer()
                Text("Score: \(viewmodel.score)")
                    .padding()
                    .frame(width: 130)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 20.0))
            }
            .navigationTitle(viewmodel.rootWord)
            .onAppear(perform: viewmodel.loadText)
            .alert(alertTitle, isPresented: $showAlert, actions: {}, message: { Text(alertMessage) })
            .onSubmit {
                switch viewmodel.submit(inputWord) {
                case .valid:
                    inputWord = ""
                case .invalid(title: let title, message: let message):
                    showAlert(title, message)
                }
            }
            .toolbar {
                Button("Change word", action: viewmodel.changeWord)
            }
        }
    }
    
    
    private func showAlert(_ title: String, _ message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    ContentView()
}
