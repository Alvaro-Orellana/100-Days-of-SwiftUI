//
//  QuizView.swift
//  Project day 35
//
//  Created by Alvaro Orellana on 14-10-24.
//

import SwiftUI


struct QuizView: View {
    
    let multiplicationTable: Int
    let numberOfQuestionsCopy: Int
    @State var numberOfQuestions: Int
    @State var score: Int = 0
    @State var randomNumber: Int = Int.random(in: 2...10)
    @State var answer: String = ""
    @State var alertTitle: String = ""
    @State var alertMessage = ""
    @State var isPresented: Bool = false
    @State var gameIsOver = false
    
    
    init(multiplicationTable: Int, numberOfQuestions: Int) {
        self.multiplicationTable = multiplicationTable
        self.numberOfQuestionsCopy = numberOfQuestions
        self.numberOfQuestions = numberOfQuestions
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(multiplicationTable) x \(randomNumber) = ?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .overlay {
                    Ellipse()
                        .fill(.blue)
                        .opacity(0.25)
                        .frame(width: 150, height: 100)
                }
            TextField("Enter your asnwer", text: $answer)
                .textFieldStyle(.roundedBorder)
                .frame(height: 80)
                .keyboardType(.numberPad)
        
            Spacer()
            HStack(spacing: 50) {
                Text("Score: \(score)")
                Text("\(numberOfQuestions) questions left")
            }
            .font(.headline)
        }
        .onSubmit(submitAnswer)
        .alert(alertTitle, isPresented: $isPresented, actions: {}, message: { Text(alertMessage) })
    }
    
    func submitAnswer() {
        guard let number = Int(answer) else {
            presentAlert(title: "Invalid input", message: "\(answer) is not a number. type again")
            return
        }
        validateAnswer(number)
        numberOfQuestions -= 1
        answer = ""
        randomNumber = Int.random(in: 2...10)
        
        guard numberOfQuestions > 0 else {
            presentAlert(title: "Game over", message: "You got \(score) out of \(numberOfQuestionsCopy) questions correct")
            return
        }
    }
    
    private func validateAnswer(_ userAnswer: Int) {
        if userAnswer == multiplicationTable * randomNumber {
            score += 1
            presentAlert(title: "Correct", message: "Score: \(score) out of \(numberOfQuestionsCopy) questions correct")
        } else {
            presentAlert(title: "Incorrect", message: "The correct answer was \(multiplicationTable * randomNumber)")
        }
    }
    
    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        isPresented = true
    }
}




#Preview {
    QuizView(multiplicationTable: 3, numberOfQuestions: 2)
}
