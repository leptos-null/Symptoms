//
//  CategoryPair.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/25/21.
//

import HealthKit

struct CategoryPair {
    enum ValueType {
        case severity        // HKCategoryValueSeverity
        case appetiteChanges // HKCategoryValueAppetiteChanges
        case presence        // HKCategoryValuePresence
        
        var range: Range<Int> {
            switch self {
            case .severity: return 0..<5
            case .appetiteChanges: return 0..<4
            case .presence: return 0..<2
            }
        }
        
        func localizedName(for value: Int) -> String {
            switch self {
            case .severity:
                guard let severity = HKCategoryValueSeverity(rawValue: value),
                      let localizedName = severity.localizedName else { return "HKCategoryValueSeverity(\(value))" }
                return localizedName
            case .appetiteChanges:
                guard let appetiteChanges = HKCategoryValueAppetiteChanges(rawValue: value),
                      let localizedName = appetiteChanges.localizedName else { return "HKCategoryValueAppetiteChanges(\(value))" }
                return localizedName
            case .presence:
                guard let presence = HKCategoryValuePresence(rawValue: value),
                      let localizedName = presence.localizedName else { return "HKCategoryValuePresence(\(value))" }
                return localizedName
            }
        }
    }
    
    let keyType: HKCategoryType
    let valueType: ValueType
    
    init(keyType: HKCategoryType, valueType: ValueType) {
        self.keyType = keyType
        self.valueType = valueType
    }
    init(_ keyType: HKCategoryType, _ valueType: ValueType) {
        self.keyType = keyType
        self.valueType = valueType
    }
    init(_ keyTypeIdentifier: HKCategoryTypeIdentifier, valueType: ValueType) {
        self.keyType = HKCategoryType(keyTypeIdentifier)
        self.valueType = valueType
    }
}

extension CategoryPair: Identifiable {
    var id: String { keyType.identifier }
}

extension CategoryPair {
    static let symptoms = [
        CategoryPair(.abdominalCramps,                    valueType: .severity),
        CategoryPair(.acne,                               valueType: .severity),
        CategoryPair(.appetiteChanges,                    valueType: .appetiteChanges),
        CategoryPair(.bladderIncontinence,                valueType: .severity),
        CategoryPair(.bloating,                           valueType: .severity),
        CategoryPair(.breastPain,                         valueType: .severity),
        CategoryPair(.chestTightnessOrPain,               valueType: .severity),
        CategoryPair(.chills,                             valueType: .severity),
        CategoryPair(.constipation,                       valueType: .severity),
        CategoryPair(.coughing,                           valueType: .severity),
        CategoryPair(.diarrhea,                           valueType: .severity),
        CategoryPair(.dizziness,                          valueType: .severity),
        CategoryPair(.drySkin,                            valueType: .severity),
        CategoryPair(.fainting,                           valueType: .severity),
        CategoryPair(.fatigue,                            valueType: .severity),
        CategoryPair(.fever,                              valueType: .severity),
        CategoryPair(.generalizedBodyAche,                valueType: .severity),
        CategoryPair(.hairLoss,                           valueType: .severity),
        CategoryPair(.headache,                           valueType: .severity),
        CategoryPair(.heartburn,                          valueType: .severity),
        CategoryPair(.hotFlashes,                         valueType: .severity),
        CategoryPair(.lossOfSmell,                        valueType: .severity),
        CategoryPair(.lossOfTaste,                        valueType: .severity),
        CategoryPair(.lowerBackPain,                      valueType: .severity),
        CategoryPair(.memoryLapse,                        valueType: .severity),
        CategoryPair(.moodChanges,                        valueType: .presence),
        CategoryPair(.nausea,                             valueType: .severity),
        CategoryPair(.nightSweats,                        valueType: .severity),
        CategoryPair(.pelvicPain,                         valueType: .severity),
        CategoryPair(.rapidPoundingOrFlutteringHeartbeat, valueType: .severity),
        CategoryPair(.runnyNose,                          valueType: .severity),
        CategoryPair(.shortnessOfBreath,                  valueType: .severity),
        CategoryPair(.sinusCongestion,                    valueType: .severity),
        CategoryPair(.skippedHeartbeat,                   valueType: .severity),
        CategoryPair(.sleepChanges,                       valueType: .presence),
        CategoryPair(.soreThroat,                         valueType: .severity),
        CategoryPair(.vaginalDryness,                     valueType: .severity),
        CategoryPair(.vomiting,                           valueType: .severity),
        CategoryPair(.wheezing,                           valueType: .severity),
    ]
}
