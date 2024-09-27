//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alvaro Orellana on 25-09-24.
//

import SwiftUI

struct ContentView: View {
    
    private static let countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    private static let numberOfFlagsPerChoice = 4
    private static let numberOfQuestions = 2
    
    @State private var countriesToShow: ArraySlice<String>
    @State private var correctAnswer: String
    @State private var alertTitle = ""
    @State private var alertMesage = ""
    @State private var presentAlert = false
    @State private var score = 0
    @State private var numberOfQuestions = Self.numberOfQuestions
    
    init() {
        let countriesToShow = Self.countries.shuffled().prefix(upTo: Self.numberOfFlagsPerChoice)
        self.countriesToShow = countriesToShow
        self.correctAnswer = countriesToShow.randomElement()!
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()

            VStack {
                Text("Guess the flag")
                    .foregroundStyle(.white)
                    .font(.largeTitle.bold())
                
                Spacer()
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                        Text(correctAnswer.capitalized)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    
                    ForEach(countriesToShow, id: \.self) { country in
                        Button {
                            flagTapped(selectedFlag: country)
                        } label: {
                            Image(country)
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                
                Text("Score is \(score)")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .alert(alertTitle, isPresented: $presentAlert) {
            Button("Ok", action: gameIsOver ? restartGame : nextQuestion)
        } message: {
            Text(alertMesage)
        }
           
    }
    
    private var gameIsOver: Bool { self.numberOfQuestions == 0 }
    
    private func flagTapped(selectedFlag: String) {
        numberOfQuestions -= 1
        presentAlert = true
        
        if selectedFlag == correctAnswer {
            score += 1
            alertTitle = "Correct"
            alertMesage = "Your score is \(score)"
        } else {
            alertTitle = "Incorrect"
            alertMesage = "That's the flag of \(selectedFlag)"
        }
        
        if gameIsOver {
            alertTitle = "Game finished"
            alertMesage = "Your total score was \(score)"
        }
    }
    
    private func nextQuestion() {
        countriesToShow = Self.countries.shuffled().prefix(upTo: Self.numberOfFlagsPerChoice)
        correctAnswer = countriesToShow.randomElement()!
    }
    
    private func restartGame() {
        score = 0
        numberOfQuestions = Self.numberOfQuestions
        nextQuestion()
    }
}

#Preview {
    ContentView()
}
