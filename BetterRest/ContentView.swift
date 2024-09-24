//
//  ContentView.swift
//  BetterRest
//
//  Created by Мария Газизова on 24.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    
    func dayRange() -> ClosedRange<Date> {
        // now + secons for a day, time after now is NOT included
        let tomorrow = Date.now.addingTimeInterval(86400)
        return Date.now...tomorrow
    }
    
    func dateComponents() {
        var components = DateComponents()
        components.hour = 8 // components are OPTIONAL
        components.minute = 0 // components are OPTIONAL
        let date = Calendar.current.date(from: components) ?? Date.now // current date 8am, date(from:) returns optional -> default value is now
        
        
        let anotherComponents = Calendar.current.dateComponents(
            [.hour, .minute],
            from: Date.now
        )
        let hour = components.hour ?? 8
        let minutes = components.minute ?? 0
    }
    
    var body: some View {
        VStack {
            Stepper("\(sleepAmount) hours",
                    value: $sleepAmount) // can have negative values, limited only sleepAmount's type
            
            Stepper("\(sleepAmount.formatted()) hours",
                    value: $sleepAmount,
                    in: 4...12,
                    step: 0.25) // according to sleepAmount's type
            
            DatePicker(("Please enter the date"), // can be used for Voice over even if labelsHidden is on
                       selection: $wakeUp,
                       displayedComponents: .hourAndMinute)
            .labelsHidden()
            
            DatePicker(("Please enter the date"),
                       selection: $wakeUp,
                       in: Date.now... // one side randes are allowed
            )
            .labelsHidden()
            
            DatePicker("Please enter the date",
                       selection: $wakeUp,
                       in: dayRange())
            .labelsHidden()
            
            // Formatting
            Text(Date.now, format: .dateTime.hour().minute())
            Text(Date.now, format: .dateTime.hour().minute().month().year())
            Text(Date.now.formatted(date: .complete, time: .shortened))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
