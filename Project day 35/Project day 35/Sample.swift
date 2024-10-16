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
            .fill(isGreen ? .green : .red)
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
    }
}

struct Checkmark: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: .init(x: rect.minX, y: rect.midY))
            p.addLine(to: .init(x: rect.minX + rect.size.width / 2,
                                y: rect.maxY))
            p.addLine(to: .init(x: rect.maxX, y: rect.minY))
        
        }
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        let p = proposal.replacingUnspecifiedDimensions()
        let length = min(p.width, p.height)
        return .init(width: length, height: length)
    }
}

#Preview {
    Sample()
        .overlay {
            Checkmark()
                .stroke(lineWidth: 3)
        }
}
