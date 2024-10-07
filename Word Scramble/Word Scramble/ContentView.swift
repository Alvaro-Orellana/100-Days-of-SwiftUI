//
//  ContentView.swift
//  Word Scramble
//
//  Created by Alvaro Orellana on 02-10-24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var words: [String] = []
    @State private var correctWords: [String] = []
    @State private var rootWord = ""
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
                    ForEach(correctWords, id: \.self) { word in
                        Label(word, systemImage: "\(word.count).circle")
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(wordSubmitted)
            .onAppear(perform: loadText)
            .alert(alertTitle, isPresented: $showAlert, actions: {}) {
                Text(alertMessage)
            }
        }
    }
    
    private func wordSubmitted() {
        // Sanitize the answer
        let answer = inputWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Make all necessary validations
        guard !answer.isEmpty else { return }
        guard isNew(word: answer) else {
            showAlert(title: "Word already used", message: "You cant use the same word you know?")
            return
        }
        guard isOriginal(word: answer) else {
            showAlert(title: "Same word", message: "You cant just copy it, be more creative")
            return
        }
        guard isPossible(word: answer) else {
            showAlert(title: "Word is not possible", message: "You can't spell that word from \(rootWord)")
            return
        }
        guard isReal(word: answer) else {
            showAlert(title: "Word not recognized", message: "You can't just make up words you know?")
            return
        }
        
        // Answer passed all the validations, continue game
        withAnimation {
            correctWords.insert(answer, at: 0)
        }
        rootWord = words.removeRandomElement()
        inputWord = ""
    }
    
    private func loadText() {
        if let textFileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let textFile = try? String(contentsOf: textFileURL, encoding: .ascii) {
                words = textFile.components(separatedBy: "\n")
                rootWord = words.removeRandomElement()
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}


// MARK: Word Validations
extension ContentView {
    private func isNew(word: String) -> Bool {
        !correctWords.contains(word)
    }
    
    private func isOriginal(word: String) -> Bool {
        rootWord != word
    }
    
    private func isPossible(word: String) -> Bool {
        var rootWord = rootWord
        for letter in word {
            if let index = rootWord.firstIndex(of: letter) {
                rootWord.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    private func isReal(word: String) -> Bool {
        let textChecker = UITextChecker()
        let wordRange = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange =  textChecker.rangeOfMisspelledWord(in: word, range: wordRange, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}



#Preview {
    ContentView()
}
