//
//  QuizView.swift
//  Project day 35
//
//  Created by Alvaro Orellana on 14-10-24.
//

import SwiftUI


struct QuizView: View {
    
    let multiplicationTable: Int
    @State var numberOfQuestions: Int
    @State var answer: String = ""
    
    @State var alertTitle: String = ""
    @State var alertMessage = ""
    @State var isPresented: Bool = false
    
    
    var body: some View {
        VStack {
            Text(generateMultiplicationQuestion())
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Enter your asnwer", text: $answer)
                .textFieldStyle(.roundedBorder)
                .frame(height: 80)
                
//                .padding()
        }
        .onSubmit {
            validateAnswer()
        }
        .alert(alertTitle, isPresented: $isPresented, actions: {})
    }
    
    func validateAnswer() {
        if let number = Double(answer) {
            alertTitle = "\(answer) successfully converted into a number"
        } else {
            alertTitle = "You cant convert a number from \(answer)"
        }
        isPresented = true
    }
    
    func generateMultiplicationQuestion() -> String {
        let randomNumber = Int.random(in: 2...10)
        return "\(multiplicationTable) x \(randomNumber) ="
    }
}



#Preview {
    QuizView(multiplicationTable: 3, numberOfQuestions: 5)
}
