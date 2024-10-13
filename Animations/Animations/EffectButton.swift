//
//  ContentView.swift
//  Animations
//
//  Created by Alvaro Orellana on 08-10-24.
//

import SwiftUI


struct ContentView3: View {
    
    let letters = Array("italo putazo")
    @State var position = CGSize.zero
    @State var isMoving = false
    @State var squarePosition: (CGFloat, CGFloat) = (0.0, 0.0)
    
    var body: some View {
        VStack {
            if isMoving {
                Rectangle()
                    .fill(.cyan)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .slide, removal: .slide))
            }
            Spacer()
            HStack {
                ForEach(letters.indices) { index in
                    Text(String(letters[index]))
                        .padding(5)
                        .font(.title)
                        .foregroundStyle(.white)
                        .background(isMoving ? Color.blue.gradient : Color.red.gradient)
                        .animation(.linear.delay(Double(index) / 20), value: position)
                        .offset(position)
                        
                }
            }
            .gesture(
                DragGesture()
                    .onChanged {
                        position = $0.translation
                        withAnimation {
                            isMoving = true
                        }
                    }
                    .onEnded { _ in
                        self.isMoving = false
                    }
            )
            Spacer()
            Rectangle()
                .fill(.blue)
                .frame(width: 50, height: 50)
                .offset(x: squarePosition.0, y: squarePosition.1)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                                self.squarePosition = (value.location.x, value.location.y)
                            
                        }
                        .onEnded { _ in
                            withAnimation {
                                squarePosition = (0,0)
                            }
                        }
                )
            
            
            Text(self.position.debugDescription)
            Text(self.squarePosition.0.description + " " + self.squarePosition.1.description)
        }
        
    }
}













struct ContentView: View {
    
    @State private var enabled = false
    @State private var rotationDegrees = 0.0
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        Button("some title") {
            rotationDegrees += 359
        }
        .frame(width: 200, height: 200)
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(.rect(cornerRadius: 60))
        .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
//                .onEnded { _ in dragAmount = .zero }
        )
        .animation(.bouncy, value: enabled)
        .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 0, y: 1, z: 0))
        .animation(.spring(duration: 1, bounce: 0.9), value: rotationDegrees)
    }
}


struct SecondContentView: View {
    
    @State var position = CGSize.zero
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { position = $0.translation }
//            .onEnded { _ in position = .zero }
    }
    
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: 100, height: 100, alignment: .center)
                .gesture(drag)
                .offset(position)
                .animation(.linear, value: position)
        }
    }
}

#Preview {
    ContentView3()
//    SecondContentView()
}
