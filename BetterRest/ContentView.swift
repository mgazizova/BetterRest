//
//  ContentView.swift
//  BetterRest
//
//  Created by Мария Газизова on 24.09.2024.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeIntake = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var idealBedtime = ""

    private var coffeeAmount: Int {
        coffeIntake + 1
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time",
                               selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .onChange(of: wakeUp) {
                        calculateBedtime()
                    }
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours",
                            value: $sleepAmount,
                            in: 4...12,
                            step: 0.25)
                    .onChange(of: sleepAmount) {
                        calculateBedtime()
                    }
                }
                
                Section("Daily cofee intake") {
                    Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeIntake) {
                        ForEach(1..<21) { number in
                            Text("^[\(number) cup](inflect: true)")
                        }
                    }
                    .onChange(of: coffeIntake) {
                        calculateBedtime()
                    }
                }
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("Ok") {}
            } message: {
                Text(alertMessage)
            }
            .navigationTitle("BetterRest")
            
            Text("Your ideal bedtime is \(idealBedtime)")
                .font(.headline)
        }
        .onAppear {
            calculateBedtime()
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute],
                                                             from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediciton = try model.prediction(wake: Double(hour + minute),
                                                  estimatedSleep: sleepAmount,
                                                  coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediciton.actualSleep
            
            idealBedtime = sleepTime.formatted(date: .omitted,
                                               time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating a bedtime"
            showingAlert = true
        }
    }
}

#Preview {
    ContentView()
}
