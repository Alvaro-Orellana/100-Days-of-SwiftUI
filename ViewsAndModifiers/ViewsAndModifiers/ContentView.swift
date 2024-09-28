//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Alvaro Orellana on 27-09-24.
//

import SwiftUI

struct ContentView: View {
    
    @State var isOn = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                        
            Button("test") {
                self.isOn.toggle()
            }
        }
        .frame(width: 200, height: 200)
        .background(isOn ? .white : .black)
        .border(
            LinearGradient(colors: [.red, .purple], startPoint: .bottom, endPoint: .top),
            width: 20
        )
        .padding()
        .background(Color.secondary)
        .padding()
        .background(Color.brown)
        .padding()
        .background(Color.cyan)
        .padding()
        .background(Color.yellow)
        .padding()
        .background(Color.orange)
        .blur(radius: 0.5)
    }
}

struct GridStack<Content: View> : View {
    let rows: Int
    let colums: Int
    @ViewBuilder let content: (_ row: Int, _ column: Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<colums, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}


#Preview {
    GridStack(rows: 3, colums: 2) { row, column in
        Text("row: \(row), cloumn: \(column)")
            .padding()
            .border(.red)
    }
    
    GridStack(rows: 4, colums: 6) { row, column in
        Color(red: Double(row), green: Double(column), blue: Double(sqrt(Double(row*column))))
    }
}
