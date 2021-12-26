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
        NavigationView {
            List(symptoms) { symptom in
                NavigationLink(symptom.keyType.localizedName) {
                    CategoryEntry(categoryPair: symptom)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
