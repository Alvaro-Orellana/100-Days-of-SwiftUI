//
//  QuizView.swift
//  Project day 35
//
//  Created by Alvaro Orellana on 14-10-24.
//

import SwiftUI


struct QuizView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var userAnswer: String = ""
    @State private var alertTitle: String = ""
    @State private var alertMessage = ""
    @State private var isPresented: Bool = false
    @State private var gameIsFinished: Bool = false
    private var viewmodel: QuizViewModel
    
    init(multiplicationTable: Int, numberOfQuestions: Int) {
        viewmodel = QuizViewModel(multiplicationTable: multiplicationTable, numberOfQuestions: numberOfQuestions)
    }
    
    var body: some View {
        VStack {
            Text("Your are doing the table of \(viewmodel.multiplicationTable)")
            Spacer()
            Text(viewmodel.currentQuestion)
                .font(.largeTitle)
                .fontWeight(.bold)
                .overlay {
                    Ellipse()
                        .fill(.blue)
                        .opacity(0.25)
                        .frame(width: 150, height: 100)
                }
            TextField("Enter your asnwer", text: $userAnswer)
                .textFieldStyle(.roundedBorder)
                .frame(height: 80)
                .keyboardType(.numberPad)
        
            Spacer()
            HStack(spacing: 50) {
                Text("Score: \(viewmodel.score)")
                Text("\(viewmodel.questionsLeft) questions left")
            }
            .font(.headline)
        }
        .onSubmit(submitAnswer)
        .alert(alertTitle, isPresented: $isPresented, actions: {}, message: { Text(alertMessage) })
        .alert(alertTitle, isPresented: $gameIsFinished) {
            Button("Ok", action: { dismiss() })
        } message: {
            Text(alertMessage)
        }

    }
    
    private func submitAnswer() {
        switch viewmodel.submitAnswer(userAnswer) {
        case .invalidInput:
            presentAlert(title: "Invalid input", message: "\(userAnswer) is not a number. type again")
        
        case .incorrect:
            presentAlert(title: "Incorrect", message: "The correct answer was \(viewmodel.correctAnswer)")
            viewmodel.nextQuestion()
        
        case .correct:
            presentAlert(title: "Correct", message: "Score: \(viewmodel.score)/\(viewmodel.numberOfQuestions)")
            viewmodel.nextQuestion()
        
        case .gameFinished:
            
            presentFinishedAlert(title: "Game over", message: "You got \(viewmodel.score) out of \(viewmodel.numberOfQuestions) questions correct")
        }
        userAnswer = ""
    }
    
    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        isPresented = true
    }
    
    private func presentFinishedAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        gameIsFinished = true
    }
}



#Preview {
    QuizView(multiplicationTable: 3, numberOfQuestions: 2)
}
