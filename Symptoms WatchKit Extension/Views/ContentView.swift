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
    let healthStore: HealthStoreProvider
    
    init(healthStore: HealthStoreProvider = HealthService.shared) {
        self.healthStore = healthStore
    }
    
    @State private var authorizationError: Error?
    
    var body: some View {
        NavigationView {
            List(symptoms) { symptom in
                NavigationLink(symptom.keyType.localizedName) {
                    CategoryEntry(categoryPair: symptom, healthStore: healthStore)
                }
            }
            .navigationTitle("Symptoms")
            .task {
                do {
                    try await healthStore.requestAuthorization(toShare: Set(symptoms.map(\.keyType)))
                } catch {
                    authorizationError = error
                }
            }
            .alert(authorizationError?.localizedDescription ?? "Unknown Health Authorization Error", isPresented: .constant(authorizationError != nil)) {
                Button("OK") {
                    authorizationError = nil
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(healthStore: AcceptHealthStore.fast)
        ContentView(healthStore: FailureHealthStore.fast)
        ContentView(healthStore: AcceptHealthStore.slow)
    }
}
