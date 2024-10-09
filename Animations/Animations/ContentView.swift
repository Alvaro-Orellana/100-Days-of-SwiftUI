//
//  ContentView.swift
//  Animations
//
//  Created by Alvaro Orellana on 08-10-24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationAmount = 1.0
    
    let title: String
    let color: Color

    
    var body: some View {
        Button(title) {
            animationAmount += 1
        }
        .padding(50)
        .foregroundStyle(.white)
        .background(color)
        .clipShape(.circle)
        .overlay {
            Circle()
                .stroke(color)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeInOut(duration: 2).repeatForever(autoreverses: false),
                    value: animationAmount
                )
        }
        
        
    }
}



#Preview {
    ContentView(title: "botton", color: .yellow)
}
