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
            .alert(alertTitle, isPresented: $showAlert, actions: {}) {
                Text(alertMessage)
            }
            .onSubmit {
                let result = viewmodel.submitWord(inputWord)
                switch result {
                case .valid: inputWord = ""
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


// MARK: Word Validations
class ViewModel: ObservableObject {
    
    @Published private var words: [String] = []
    @Published var correctWords: [String] = []
    @Published var rootWord: String = ""
    
    // MARK: Add future validations in this array
    private lazy var validations: [(String) -> ValidationResult] = [isNotEmpty, isNew, isOriginal, isReal, isPossible]

    
    enum ValidationResult: Equatable {
        case valid
        case invalid(title: String, message: String)
        
        var isInvalid: Bool {
            switch self {
            case .valid: false
            case .invalid(title: _, message: _): true
            }
        }
    }
    
    func loadText() {
        if let textFileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let textFile = try? String(contentsOf: textFileURL, encoding: .ascii) {
                words = textFile.components(separatedBy: "\n")
                rootWord = words.removeRandomElement()
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func submitWord(_ inputWord: String) -> ValidationResult {
        // Sanitize the answer
        let answer = inputWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let result = validate(answer)
        if result == .valid {
            correctWords.insert(answer, at: 0)
            rootWord = words.removeRandomElement()
        }
        return result
    }
    
    private func validate(_ word: String) -> ValidationResult {
        for validation in validations {
            let result = validation(word)
            if result.isInvalid {
                return result
            }
        }
        return .valid
    }
 
    private func isNotEmpty(word: String) -> ValidationResult {
        if word.isEmpty {
            .invalid(title: "Empty input", message: "thats cheating bro")
        } else {
            .valid
        }
    }
    
    private func isNew(word: String) -> ValidationResult {
        if correctWords.contains(word) {
            .invalid(title: "Word already used", message: "You cant use the same word you know?")
        } else {
            .valid
        }
    }
    
    private func isOriginal(word: String) -> ValidationResult {
        if rootWord == word {
            .invalid(title: "Same word", message: "You cant just copy it, be more creative")
        } else {
            .valid
        }
    }
    
    private func isPossible(word: String) -> ValidationResult {
        var rootWord = rootWord
        for letter in word {
            if let index = rootWord.firstIndex(of: letter) {
                rootWord.remove(at: index)
            } else {
                return .invalid(title: "Word is not possible", message: "You can't spell \(word) that word from \(rootWord)")
            }
        }
        return .valid
    }
    
    private func isReal(word: String) -> ValidationResult {
        let textChecker = UITextChecker()
        let wordRange = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange =  textChecker.rangeOfMisspelledWord(in: word, range: wordRange, startingAt: 0, wrap: false, language: "en")
        
        if misspelledRange.location == NSNotFound {
            return .valid
        } else {
            return .invalid(title: "Word not recognized", message: "You can't just make up words you know?")
        }
    }
}

/*
 
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
 */


#Preview {
    ContentView()
}
