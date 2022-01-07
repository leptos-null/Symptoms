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
    let healthStore: HealthStoreProvider
    
    private enum SaveState: Equatable {
        case initial
        case saving
        case success
        case failure(Error)
        
        static func == (lhs: SaveState, rhs: SaveState) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial): return true
            case (.saving,  .saving):  return true
            case (.success, .success): return true
            case (.failure, .failure): return true
            default: return false
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selection: Int = 0
    @State private var saveState: SaveState = .initial
    
    private var localizedButtonText: String {
        switch saveState {
        case .initial: return "Save"
        case .saving:  return "Saving"
        case .success: return "Saved"
        case .failure: return "Error"
        }
    }
    
    private var buttonImageName: String {
        switch saveState {
        case .initial: return "checkmark.circle"
        case .saving:  return "checkmark.circle"
        case .success: return "checkmark.circle"
        case .failure: return "xmark.circle"
        }
    }
    
    private var buttonBackground: Color {
        switch saveState {
        case .initial: return .white
        case .saving:  return .white
        case .success: return .green
        case .failure: return .red
        }
    }
    
    private var buttonForeground: Color {
        switch saveState {
        case .initial: return .green
        case .saving:  return .green
        case .success: return .green
        case .failure: return .red
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Group {
                if case .failure(let error) = saveState {
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                } else {
                    Picker(selection: $selection) {
                        ForEach(categoryPair.valueType.range) { value in
                            Text(categoryPair.valueType.localizedName(for: value))
                        }
                    } label: {
                        // the Picker initializer that takes a title string
                        // results in really small text on 40mm and 44mm devices.
                        Text(categoryPair.keyType.localizedName)
                            .font(.headline)
                            .allowsTightening(true)
                    }
                    .disabled(saveState != .initial)
                }
            }
            .transition(.opacity.animation(.easeIn(duration: 0.125)))
            
            Spacer()
            
            Button {
                let now = Date()
                let sample = HKCategorySample(type: categoryPair.keyType, value: selection, start: now, end: now)
                Task(priority: .userInitiated) {
                    saveState = .saving
                    do {
                        try await healthStore.save(sample)
                        saveState = .success
                        
                        try await Task.sleep(nanoseconds: 875_000_000) // 0.875 seconds
                        dismiss()
                    } catch {
                        saveState = .failure(error)
                        
                        try await Task.sleep(nanoseconds: 1_750_000_000) // 1.75 seconds
                        saveState = .initial
                    }
                }
            } label: {
                Label(localizedButtonText, systemImage: buttonImageName)
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(buttonForeground)
            .tint(buttonBackground.opacity(0.125))
            .disabled(saveState != .initial)
            .animation(.linear(duration: 0.25), value: saveState)
        }
    }
}

struct CategoryEntry_Previews: PreviewProvider {
    static var previews: some View {
        CategoryEntry(categoryPair: CategoryPair(.coughing, valueType: .severity), healthStore: AcceptHealthStore.fast)
        CategoryEntry(categoryPair: CategoryPair(.dizziness, valueType: .severity), healthStore: FailureHealthStore.fast)
        CategoryEntry(categoryPair: CategoryPair(.fatigue, valueType: .severity), healthStore: AcceptHealthStore.slow)
    }
}
