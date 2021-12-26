//
//  ContentView.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/25/21.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    let symptoms: [CategoryPair] = CategoryPair.symptoms.sorted { $0.keyType.localizedName < $1.keyType.localizedName }
    
    var body: some View {
        List(symptoms) { symptom in
            NavigationLink {
                if symptom.valueType is HKCategoryValueSeverity.Type {
                    CategoryEntry(category: symptom.keyType, range: 0..<5) { value in
                        guard let severity = HKCategoryValueSeverity(rawValue: value),
                              let localizedName = severity.localizedName else { return "HKCategoryValueSeverity(\(value))" }
                        return localizedName
                    }
                } else if symptom.valueType is HKCategoryValueAppetiteChanges.Type {
                    CategoryEntry(category: symptom.keyType, range: 0..<4) { value in
                        guard let appetiteChanges = HKCategoryValueAppetiteChanges(rawValue: value),
                              let localizedName = appetiteChanges.localizedName else { return "HKCategoryValueAppetiteChanges(\(value))" }
                        return localizedName
                    }
                } else if symptom.valueType is HKCategoryValuePresence.Type {
                    CategoryEntry(category: symptom.keyType, range: 0..<2) { value in
                        guard let presence = HKCategoryValuePresence(rawValue: value),
                              let localizedName = presence.localizedName else { return "HKCategoryValuePresence(\(value))" }
                        return localizedName
                    }
                } else {
                    Text("Unsupported type: \(String(describing: symptom.valueType))")
                }
            } label: {
                Text(symptom.keyType.localizedName)
            }
        }
        .navigationTitle("Symptoms")
        .onAppear {
            HealthService.shared.healthStore.requestAuthorization(toShare: Set(symptoms.map(\.keyType)), read: nil) { success, error in
                print("requestAuthorization", success, String(describing: error))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
