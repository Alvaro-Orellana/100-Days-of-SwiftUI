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
    private static let flagWidth: CGFloat = 200
    
    @State private var countriesToShow: ArraySlice<String>
    @State private var correctAnswer: String
    @State private var alertTitle = ""
    @State private var alertMesage = ""
    @State private var presentAlert = false
    @State private var score = 0
    @State private var numberOfQuestions = Self.numberOfQuestions
    @State var tappedFlagName = ""
    
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
                    .font(.largeTitle.bold())
                                
                VStack {
                    Text("Tap the flag of")
                        .font(.subheadline.weight(.heavy))
                    Text(correctAnswer.capitalized)
                        .font(.largeTitle.weight(.semibold))

                    flags
//                        .frame(width: 200)
                        .frame(maxWidth: 200, minHeight: 100)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Text("Score is \(score)")
                    .titleStyle()
            }
            .foregroundStyle(.white)
            .padding()
        }
        .alert(alertTitle, isPresented: $presentAlert) {
            Button("Ok", action: gameIsOver ? restartGame : newQuestion)
        } message: {
            Text(alertMesage)
        }
    }
    
    private var flags: some View {
        ForEach(countriesToShow, id: \.self) { country in
            Button {
                flagTapped(selectedFlag: country)
            } label: {
                GeometryReader { geometryProxy in
                    FlagImage(imageName: country)
                        .opacity(calculateOpacity(countryName: country))
                        .animation(.default.delay(0.2), value: presentAlert)
                    
                        
                    
//                        .scaleEffect(calculateScale(countryName: country, size: geometryProxy.size))
                        .rotation3DEffect(calculateDegrees(countryName: country), axis: (x: 0, y: 1, z: 0))
                        .animation(.snappy(duration: 2, extraBounce: 0.6).delay(0.1), value: presentAlert)
                        .border(.blue, width: 2)
                }
                .border(.red, width: 2)
                
            }
        }
    }
    
//    private func calculateScale(countryName: String, size: CGSize) -> CGSize {
//        print(size)
//        if tappedFlagName != countryName && !tappedFlagName.isEmpty {
//            return CGSize(width: size.width * 0.5, height: size.height * 0.5)
//        } else {
//            size
//        }
//    }
    
    private func calculateOpacity(countryName: String) -> Double {
        tappedFlagName == countryName || tappedFlagName.isEmpty ? 1 : 0.25
    }
    
    private func calculateDegrees(countryName: String) -> Angle {
        Angle.degrees(tappedFlagName == countryName && !tappedFlagName.isEmpty ? 360 : 0)
    }
    
    private var gameIsOver: Bool { self.numberOfQuestions == 0 }
    
    private func flagTapped(selectedFlag: String) {
        numberOfQuestions -= 1
        presentAlert = true
        tappedFlagName = selectedFlag
        
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
    
    private func newQuestion() {
        countriesToShow = Self.countries.shuffled().prefix(upTo: Self.numberOfFlagsPerChoice)
        correctAnswer = countriesToShow.randomElement()!
        tappedFlagName = ""
    }
    
    private func restartGame() {
        score = 0
        numberOfQuestions = Self.numberOfQuestions
        newQuestion()
    }
}

struct FlagImage: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
    }
}

extension View where Self == Text {
    func titleStyle() -> some View {
        self.modifier(TitleStyle())
    }
}

#Preview {
    ContentView()
}
