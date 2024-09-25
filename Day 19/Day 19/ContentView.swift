//
//  ContentView.swift
//  Day 19
//
//  Created by Alvaro Orellana on 03-09-24.
//

import SwiftUI

struct ContentView: View {
    
    @State var unitsQuantity = ""
    @State var inputUnit: LengthUnit = .meters
    @State var outputUnit: LengthUnit = .meters
        
    var body: some View {
        Form {
            Section {
                Picker("Input unit", selection: $inputUnit) {
                    ForEach(LengthUnit.allCases) { unit in
                        Text(unit.rawValue)
                    }
                }
                .pickerStyle(.menu)
                TextField("Amount in input unit", text: $unitsQuantity)
            }
            Section("Output unit") {
                Picker("Output unit", selection: $outputUnit) {
                    ForEach(LengthUnit.allCases) { unit in
                        Text(unit.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
            if unitsQuantity.isEmpty {
                Text("enter the input amount")
            } else {
                Text("\(unitsQuantity) \(inputUnit) is equal to \(convertUnits().formatted()) \(outputUnit)")
            }
        }
    }
    
    private func convertUnits() -> Double {
        LengthUnit.convert(from: inputUnit, to: outputUnit, quantity: Double(unitsQuantity) ?? 0)
    }
}

enum LengthUnit: String, Identifiable, CaseIterable {
    case centimeters
    case meters
    case kilometers
    case feet
    case yards
    case miles
    
    var id: Self {
        self
    }
    
    // Coefficient to convert from given unit to base unit (meters)
    // Multiply the given value with this coefficient to convert to meters
    private var ratioOfmetersPerUnit: Double {
        switch self {
        case .centimeters: 1 / 100
        case .meters: 1 / 1
        case .kilometers: 1 / 0.001
        case .feet: 1 / 3.28084
        case .yards: 1 / 1.09361
        case .miles: 1 / 0.000539957
        }
    }
    
    static func convert(from sourceUnit: LengthUnit, to destinationUnit: LengthUnit, quantity: Double) -> Double {
        let quantityInMeters = sourceUnit.ratioOfmetersPerUnit * quantity
        let quantityInDestinationUnit = quantityInMeters / destinationUnit.ratioOfmetersPerUnit
        return quantityInDestinationUnit
    }
}


#Preview {
    ContentView()
}
