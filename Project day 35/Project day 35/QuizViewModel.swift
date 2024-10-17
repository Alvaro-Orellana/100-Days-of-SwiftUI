//
//  QuizViewModel.swift
//  Project day 35
//
//  Created by Alvaro Orellana on 16-10-24.
//

import Foundation


@Observable class QuizViewModel {
    
    let multiplicationTable: Int
    private let questions: [QuestionModel]
    private var questionNumber = 0
    private(set) var score: Int = 0
    
    
    init(multiplicationTable: Int, numberOfQuestions: Int) {
        self.multiplicationTable = multiplicationTable
        questions = (1...numberOfQuestions).map { _ in QuestionModel(from: multiplicationTable) }
    }
    
    var currentQuestion: String { questions[questionNumber].question }
    
    var correctAnswer: String { questions[questionNumber].answer.description }
    
    var questionsLeft: Int { questions.count - questionNumber }

    var numberOfQuestions: Int { questions.count }
    

    func submitAnswer(_ userAnswer: String) -> QuestionResult {
        guard let number = Int(userAnswer) else {
            return .invalidInput
        }
        guard questionNumber + 1 < questions.count else {
            // Game is on the last question
            if number == questions[questionNumber].answer {
                score += 1
            }
            return .gameFinished
        }
        
        if number == questions[questionNumber].answer {
            score += 1
            return .correct
        } else {
            return .incorrect
        }
    }
    
    func nextQuestion() {
        questionNumber += 1
    }

    
    enum QuestionResult {
        case invalidInput
        case incorrect
        case correct
        case gameFinished
    }
        
}

struct QuestionModel {
    let question: String
    let answer: Int
    
    init(from multiplicationTable: Int) {
        let randomNumber = Int.random(in: 2...10)
        let answer = multiplicationTable * randomNumber
        
        self.question = "\(multiplicationTable) x \(randomNumber) = ?"
        self.answer = answer
    }
}
