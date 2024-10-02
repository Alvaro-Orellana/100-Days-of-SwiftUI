//
//  ContentView.swift
//  BetterRest
//
//  Created by Alvaro Orellana on 30-09-24.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var wakeUpTime: Date = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .center, spacing: 0) {
                    Text("When do you want to wake up")
                    DatePicker("Please enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 2...10, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                    Stepper("^[\(coffeeAmount) cup of coffee](inflect: true)", value: $coffeeAmount, in: 1...20)
                }
            }
            .font(.headline)
            .padding()
            .navigationTitle("Better Rest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Text(alertMessage)
                Button("Ok", role: .cancel) {}
            }
        }
    }
    
    private static var defaultWakeTime: Date {
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0
        
        return Calendar.current.date(from: dateComponents) ?? .now
    }
    
    private func calculateBedTime() {
        do {
            let model = try SleepCalculator(configuration: MLModelConfiguration())
            let prediction = try model.prediction(wake: Double(wakeUpTime.secondsSinceMidnight), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let goToBedTime = wakeUpTime - prediction.actualSleep
            
            alertTitle = "You should go to bet at"
            alertMessage = goToBedTime.formatted(date: .omitted, time: .shortened)
        }
        catch {
            alertTitle = "Error"
            alertMessage = "There was an error either loading the model or making the predicction"
        }
        showAlert = true
    }
}

extension Date {
    var secondsSinceMidnight: Int {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: self)
        
        let hoursInSeconds = (dateComponents.hour ?? 0) * 60 * 60
        let minutesInSeconds = (dateComponents.minute ?? 0) * 60
        let seconds = dateComponents.second ?? 0
        
        return hoursInSeconds + minutesInSeconds + seconds
    }
}

#Preview {
    ContentView()
}
