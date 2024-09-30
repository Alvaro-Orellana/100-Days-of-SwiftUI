//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Alvaro Orellana on 29-09-24.
//

import SwiftUI

struct ContentView: View {
    
    static let numberOfQuestions = 10
    
    @State var score = 0
    
    var body: some View {
        let appsMove = PlayOptions.allCases.randomElement()!
        let playerShouldWin = Bool.random()
        
        ZStack {
            LinearGradient(colors: [.purple, .indigo, .blue,], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
            VStack(spacing: 40) {
                Text("The app chose \(appsMove.rawValue)")
                    .font(.system(size: 35))
                
                Text(playerShouldWin ? "You should win this round" : "You should loose this round")
                    .font(.title3)
                
                ForEach(PlayOptions.allCases) { option in
                    Button {
                        playGame(playerChoice: option, appsChoice: appsMove, playerShouldWin: playerShouldWin)
                    } label: {
                        Text(option.rawValue)
                            .font(.system(size: 80))
                    }
              }
                Spacer()
                
                Text("Your score: \(score)")
                    .font(.title)
            }
            .foregroundStyle(.white)
            .padding(.vertical)
        }
    }
    
    private func playGame(playerChoice: PlayOptions, appsChoice: PlayOptions, playerShouldWin: Bool) {
        let playerWon = playerWon(playerChoice: playerChoice, appsChoice: appsChoice)
        if playerWon && playerShouldWin {
            score += 1
        }
        if !playerWon && !playerShouldWin {
            score += 1
        }
        
    }
    
    // Returns true if player won, and false if app won
    private func playerWon(playerChoice: PlayOptions, appsChoice: PlayOptions) -> Bool {
        switch (playerChoice, appsChoice) {
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper): true
        default: false
        }
    }
}

enum PlayOptions: String, CaseIterable, Identifiable {
    case rock = "👊"
    case paper = "🖐️"
    case scissors = "✌️"
    
    var id: Self { self }
}

#Preview {
    ContentView()
}
