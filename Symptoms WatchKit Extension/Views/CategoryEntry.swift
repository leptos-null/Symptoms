//
//  CategoryEntry.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/26/21.
//

import SwiftUI
import HealthKit

struct CategoryEntry: View {
    let categoryPair: CategoryPair
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selection: Int = 0
    @State private var success: Bool?
    
    var body: some View {
        VStack {
            Picker(categoryPair.keyType.localizedName, selection: $selection) {
                ForEach(categoryPair.valueType.range) { value in
                    Text(categoryPair.valueType.localizedName(for: value))
                }
            }
            
            Button {
                let now = Date()
                let sample = HKCategorySample(type: categoryPair.keyType, value: selection, start: now, end: now)
                Task(priority: .userInitiated) {
                    do {
                        try await HealthService.shared.save(sample)
                        self.success = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.dismiss()
                        })
                    } catch {
                        self.success = false
                    }
                    
                }
            } label: {
                Label(
                    success == nil ? "Save" : (success == true ? "Saved" : "Error"),
                    systemImage: success != false ? "checkmark.circle" : "x.circle"
                )
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(success != false ? .green : .red)
            .tint((success == nil ? Color.white : (success == true ? .green : .red)).opacity(0.125))
            .disabled(success != nil)
            .animation(.linear(duration: 0.25), value: success)
        }
    }
}

struct CategoryEntry_Previews: PreviewProvider {
    static var previews: some View {
        CategoryEntry(categoryPair: CategoryPair(.dizziness, valueType: .severity))
    }
}
