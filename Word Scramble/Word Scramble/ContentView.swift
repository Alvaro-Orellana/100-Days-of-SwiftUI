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
            .navigationTitle(viewmodel.rootWord)
            .onAppear(perform: viewmodel.loadText)
            .alert(alertTitle, isPresented: $showAlert, actions: {}, message: { Text(alertMessage)} )
            .onSubmit {
                switch viewmodel.submitWord(inputWord) {
                case .valid:
                    inputWord = ""
                case .invalid(title: let title, message: let message):
                    showAlert(title: title, message: message)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    ContentView()
}
