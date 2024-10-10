//
//  ContentView.swift
//  Animations
//
//  Created by Alvaro Orellana on 08-10-24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationAmount = 1.0
    @State private var rotationAmount = 0.0
    let title: String
    let color: Color
    
    var body: some View {
        Button(title) {
            withAnimation(.spring(duration: 3, bounce: 0.5)) {
               rotationAmount += 360
                
            }
        }
            .padding(50)
            .foregroundStyle(.white)
            .background(color)
            .clipShape(.circle)
            .rotation3DEffect(.degrees(rotationAmount), axis: (x: 0.3, y: 1, z: 0))
//            .overlay {
//                Circle()
//                    .stroke()
//                    .foregroundStyle(color)
//                    .scaleEffect(animationAmount)
//                    .opacity(2-animationAmount)
//                    .animation(.easeInOut(duration: 2).repeatForever(), value: animationAmount)
//                
//            }
    }
}


#Preview {
    ContentView(title: "botton", color: .yellow)
}
