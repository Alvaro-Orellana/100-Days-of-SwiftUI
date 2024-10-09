//
//  TruckView.swift
//  Animations
//
//  Created by Alvaro Orellana on 08-10-24.
//

import SwiftUI

struct TruckView: View {
    @State private var driveForward = true
    
    private var driveAnimation: Animation {
        .easeInOut
        //        .repeatCount(5, autoreverses: true)
        .speed(0.3)
        .repeatForever()
    }
    
    var body: some View {
        VStack(alignment: driveForward ? .leading : .trailing, spacing: 40) {
            Image(systemName: "box.truck")
                .font(.system(size: 28))
                .border(.brown, width: 3)
                .animation(driveAnimation, value: driveForward)
            
            HStack {
                Spacer()
                Button("Animate") {
                    driveForward.toggle()
                }
                Spacer()
            }
            .border(.brown, width: 3)
        }
        .border(.brown, width: 3)
    
    }
}

#Preview {
    TruckView()
}
