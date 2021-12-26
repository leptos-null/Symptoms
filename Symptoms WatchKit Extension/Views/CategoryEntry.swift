//
//  CategoryEntry.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/26/21.
//

import SwiftUI
import HealthKit

struct CategoryEntry: View {
    let category: HKCategoryType
    let range: Range<Int>
    let valueProvider: ((Int) -> String)
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selection: Int = 0
    @State private var success: Bool?
    
    var body: some View {
        VStack {
            Picker(category.localizedName, selection: $selection) {
                ForEach(range) { value in
                    Text(valueProvider(value))
                }
            }
            
            Button {
                let now = Date()
                let sample = HKCategorySample(type: category, value: selection, start: now, end: now)
                HealthService.shared.healthStore.save(sample) { success, error in
                    self.success = success
                    guard success else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
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
