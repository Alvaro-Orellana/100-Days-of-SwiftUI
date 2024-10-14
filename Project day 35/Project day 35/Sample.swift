//
//  Sample.swift
//  Project day 35
//
//  Created by Alvaro Orellana on 14-10-24.
//

import SwiftUI

struct Sample: View {
   @State var isGreen = true
    @State var scale = CGSize(width: 1, height: 1)
    
    var body: some View {
        Circle()
            .fill(isGreen ? Color.green : Color.red)
            .frame(width: 200, height: 200)
            .animation(.default, value: isGreen)
            .onTapGesture {
                isGreen.toggle()
                scale.width *= 2
                scale.height *= 2
            }
            .background {
                Circle()
                    .stroke(lineWidth: 3)
                    .fill(isGreen ? Color.green : Color.red)
                    .opacity(isGreen ? 1 : 0)
                    .scaleEffect(scale)
                    .animation(.easeInOut.repeatForever(autoreverses: false).speed(0.2), value: scale)
                    
            }
            .overlay(alignment: .center) {
                Text("e")
                    .font(.largeTitle)
                    
            }
    }
}

#Preview {
    Sample()
}
