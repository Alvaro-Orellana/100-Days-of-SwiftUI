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
    
    @State private var countriesToShow: ArraySlice<String>
    @State private var correctAnswer: String
    @State private var alertTitle = ""
    @State private var presentAlert = false
    @State private var score = 0
    
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
                            buttonPressed(selectedFlag: country)
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
                
                Text("Score is ??")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .alert(alertTitle, isPresented: $presentAlert) {
            Button("Ok", action: nextQuestion)
        } message: {
            Text("Your score is \(score)")
        }
           
    }
    
    func buttonPressed(selectedFlag: String) {
        presentAlert = true
        if selectedFlag == correctAnswer {
            score += 1
            alertTitle = "Correct"
        } else {
            alertTitle = "Incorrect"
        }
    }
    
    func nextQuestion() {
        countriesToShow = Self.countries.shuffled().prefix(upTo: Self.numberOfFlagsPerChoice)
        correctAnswer = countriesToShow.randomElement()!
    }
}

#Preview {
    ContentView()
}
