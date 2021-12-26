//
//  CategoryPair.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/25/21.
//

import HealthKit

struct CategoryPair {
    let keyType: HKCategoryType
    let valueType: Any.Type
    
    init(keyType: HKCategoryType, valueType: Any.Type) {
        self.keyType = keyType
        self.valueType = valueType
    }
    init(_ keyType: HKCategoryType, _ valueType: Any.Type) {
        self.keyType = keyType
        self.valueType = valueType
    }
    init(_ keyTypeIdentifier: HKCategoryTypeIdentifier, valueType: Any.Type) {
        self.keyType = HKCategoryType(keyTypeIdentifier)
        self.valueType = valueType
    }
}

extension CategoryPair: Identifiable {
    var id: String { keyType.identifier }
}

extension CategoryPair {
    static let symptoms = [
        CategoryPair(.abdominalCramps,                    valueType: HKCategoryValueSeverity.self),
        CategoryPair(.acne,                               valueType: HKCategoryValueSeverity.self),
        CategoryPair(.appetiteChanges,                    valueType: HKCategoryValueAppetiteChanges.self),
        CategoryPair(.bladderIncontinence,                valueType: HKCategoryValueSeverity.self),
        CategoryPair(.bloating,                           valueType: HKCategoryValueSeverity.self),
        CategoryPair(.breastPain,                         valueType: HKCategoryValueSeverity.self),
        CategoryPair(.chestTightnessOrPain,               valueType: HKCategoryValueSeverity.self),
        CategoryPair(.chills,                             valueType: HKCategoryValueSeverity.self),
        CategoryPair(.constipation,                       valueType: HKCategoryValueSeverity.self),
        CategoryPair(.coughing,                           valueType: HKCategoryValueSeverity.self),
        CategoryPair(.diarrhea,                           valueType: HKCategoryValueSeverity.self),
        CategoryPair(.dizziness,                          valueType: HKCategoryValueSeverity.self),
        CategoryPair(.drySkin,                            valueType: HKCategoryValueSeverity.self),
        CategoryPair(.fainting,                           valueType: HKCategoryValueSeverity.self),
        CategoryPair(.fatigue,                            valueType: HKCategoryValueSeverity.self),
        CategoryPair(.fever,                              valueType: HKCategoryValueSeverity.self),
        CategoryPair(.generalizedBodyAche,                valueType: HKCategoryValueSeverity.self),
        CategoryPair(.hairLoss,                           valueType: HKCategoryValueSeverity.self),
        CategoryPair(.headache,                           valueType: HKCategoryValueSeverity.self),
        CategoryPair(.heartburn,                          valueType: HKCategoryValueSeverity.self),
        CategoryPair(.hotFlashes,                         valueType: HKCategoryValueSeverity.self),
        CategoryPair(.lossOfSmell,                        valueType: HKCategoryValueSeverity.self),
        CategoryPair(.lossOfTaste,                        valueType: HKCategoryValueSeverity.self),
        CategoryPair(.lowerBackPain,                      valueType: HKCategoryValueSeverity.self),
        CategoryPair(.memoryLapse,                        valueType: HKCategoryValueSeverity.self),
        CategoryPair(.moodChanges,                        valueType: HKCategoryValuePresence.self),
        CategoryPair(.nausea,                             valueType: HKCategoryValueSeverity.self),
        CategoryPair(.nightSweats,                        valueType: HKCategoryValueSeverity.self),
        CategoryPair(.pelvicPain,                         valueType: HKCategoryValueSeverity.self),
        CategoryPair(.rapidPoundingOrFlutteringHeartbeat, valueType: HKCategoryValueSeverity.self),
        CategoryPair(.runnyNose,                          valueType: HKCategoryValueSeverity.self),
        CategoryPair(.shortnessOfBreath,                  valueType: HKCategoryValueSeverity.self),
        CategoryPair(.sinusCongestion,                    valueType: HKCategoryValueSeverity.self),
        CategoryPair(.skippedHeartbeat,                   valueType: HKCategoryValueSeverity.self),
        CategoryPair(.sleepChanges,                       valueType: HKCategoryValuePresence.self),
        CategoryPair(.soreThroat,                         valueType: HKCategoryValueSeverity.self),
        CategoryPair(.vaginalDryness,                     valueType: HKCategoryValueSeverity.self),
        CategoryPair(.vomiting,                           valueType: HKCategoryValueSeverity.self),
        CategoryPair(.wheezing,                           valueType: HKCategoryValueSeverity.self),
    ]
}
