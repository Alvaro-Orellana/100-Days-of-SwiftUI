//
//  ViewModel.swift
//  Word Scramble
//
//  Created by Alvaro Orellana on 07-10-24.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published private var words: [String] = []
    @Published var correctWords: [String] = []
    @Published var rootWord: String = ""
    
    enum ValidationResult {
        case valid
        case invalid(title: String, message: String)
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
        
        guard isNotEmpty(word: answer) else {
            return .invalid(title: "Empty word", message: "write at least something bro")
        }
        guard isNew(word: answer) else {
            return .invalid(title: "Word already used", message: "You already used \(answer) before, try something new")
        }
        guard isOriginal(word: answer) else {
            return .invalid(title: "Same word", message: "You cant just use the same word you know?")
        }
        guard isPossible(word: answer) else {
            return .invalid(title: "Word is not possible", message: "You can't spell \(answer) that word from \(rootWord)")
        }
        guard isReal(word: answer) else {
            return .invalid(title: "Word not recognized", message: "You can't just make up words you know?")
        }
        
        // Answer passed all validations
        correctWords.insert(answer, at: 0)
        rootWord = words.removeRandomElement()
        return .valid
    }
}


// MARK: Word validation logic
private extension ViewModel {
    func isNotEmpty(word: String) -> Bool {
        !word.isEmpty
    }
    
    func isNew(word: String) -> Bool {
        !correctWords.contains(word)
    }
    
    func isOriginal(word: String) -> Bool {
        rootWord != word
    }
    
    func isPossible(word: String) -> Bool {
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
    
    func isReal(word: String) -> Bool {
        let textChecker = UITextChecker()
        let wordRange = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange =  textChecker.rangeOfMisspelledWord(in: word, range: wordRange, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}
