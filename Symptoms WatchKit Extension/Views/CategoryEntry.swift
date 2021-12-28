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
    
    private enum SaveState: Equatable {
        case initial
        case saving
        case success
        case failure(Error)
        
        static func == (lhs: SaveState, rhs: SaveState) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial): return true
            case (.saving, .saving):   return true
            case (.success, .success): return true
            case (.failure(_), .failure(_)): return true
            default: return false
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selection: Int = 0
    @State private var saveState: SaveState = .initial
    
    private var buttonText: String {
        switch saveState {
        case .initial: return "Save"
        case .saving: return "Saving"
        case .success: return "Saved"
        case .failure(_): return "Error"
        }
    }
    
    private var buttonImageName: String {
        switch saveState {
        case .initial: return "checkmark.circle"
        case .saving: return "checkmark.circle"
        case .success: return "checkmark.circle"
        case .failure(_): return "xmark.circle"
        }
    }
    
    private var buttonBackground: Color {
        switch saveState {
        case .initial: return .white
        case .saving: return .white
        case .success: return .green
        case .failure(_): return .red
        }
    }
    
    private var buttonForeground: Color {
        switch saveState {
        case .initial: return .green
        case .saving: return .green
        case .success: return .green
        case .failure(_): return .red
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
                    Picker(categoryPair.keyType.localizedName, selection: $selection) {
                        ForEach(categoryPair.valueType.range) { value in
                            Text(categoryPair.valueType.localizedName(for: value))
                        }
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
                        try await HealthService.shared.save(sample)
                        saveState = .success
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.875) {
                            dismiss()
                        }
                    } catch {
                        saveState = .failure(error)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                            saveState = .initial
                        }
                    }
                }
            } label: {
                Label(buttonText, systemImage: buttonImageName)
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
        CategoryEntry(categoryPair: CategoryPair(.dizziness, valueType: .severity))
    }
}
