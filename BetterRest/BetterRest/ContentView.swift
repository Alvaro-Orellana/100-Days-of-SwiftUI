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

    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up") {
                    DatePicker("Please enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 2...10, step: 0.25)
                }
                Section("Daily coffee intake") {
                    Picker("Cups of coffee per day", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                }
                Section(alertTitle) {
                    Text(alertMessage)
                        .font(.largeTitle.weight(.heavy))
                }
            }
            .padding()
            .font(.headline)
            .navigationTitle("Better Rest")
            .onChange(of: sleepAmount, calculateBedTime)
            .onChange(of: coffeeAmount, calculateBedTime)
            .onChange(of: wakeUpTime, calculateBedTime)
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
