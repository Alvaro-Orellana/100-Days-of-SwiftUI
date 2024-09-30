//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Alvaro Orellana on 29-09-24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var numberOfQuestions = 10
    @State private var score = 0
    @State var gameIsOver: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .indigo, .blue,], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                let appChoice = PlayOptions.allCases.randomElement()!
                let playerShouldWin = Bool.random()
                
                Text("The app chose \(appsChoice.rawValue)")
                    .font(.system(size: 35))
                
                Text(playerShouldWin ? "You should win this round" : "You should loose this round")
                    .font(.title3)
                
                ForEach(PlayOptions.allCases) { choice in
                    Button {
                        playGame(playerChoice: choice, appsChoice: appChoice, playerShouldWin: playerShouldWin)
                    } label: {
                        Text(choice.rawValue)
                            .font(.system(size: 80))
                    }
                }
                Spacer()
                
                HStack {
                    Text("Your score: \(score)")
                    Text("Remaining turns: \(numberOfQuestions)")
                }
                .font(.system(size: 22))
            }
            .foregroundStyle(.white)
            .padding(.vertical)
            .alert("Game over", isPresented: $gameIsOver) {
                Button("Ok", role: .cancel, action: newGame)
            }
        }
    }
    
    private func playGame(playerChoice: PlayOptions, appsChoice: PlayOptions, playerShouldWin: Bool) {
        let gameResult = gameResult(playerChoice: playerChoice, appsChoice: appsChoice)
        
        let playerWonCorrectly = gameResult == .playerWin  && playerShouldWin
        let playerLostCorrectly = gameResult == .playerLost && !playerShouldWin
        
        if playerWonCorrectly || playerLostCorrectly {
            score += 1
        } else {
            score -= 1
        }
        numberOfQuestions -= 1
        if numberOfQuestions == 0 {
            gameIsOver = true
        }
    }
    
    private func gameResult(playerChoice: PlayOptions, appsChoice: PlayOptions) -> PlayerGameResult {
        switch (playerChoice, appsChoice) {
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper): .playerWin
        case (.rock, .rock), (.scissors, .scissors), (.paper, .paper): .tie
        default: .playerLost
        }
    }
    
    private func newGame() {
        score = 0
        numberOfQuestions = 10
        gameIsOver = false
    }
}

enum PlayOptions: String, CaseIterable, Identifiable {
    case rock = "👊"
    case paper = "🖐️"
    case scissors = "✌️"
    
    var id: Self { self }
}

enum PlayerGameResult {
    case playerWin
    case playerLost
    case tie
}

#Preview {
    ContentView()
}
