//
//  HKCategoryType+Localization.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/25/21.
//

import HealthKit

extension HKCategoryType {
    var localizedName: String {
        switch HKCategoryTypeIdentifier(rawValue: identifier) {
        case .abdominalCramps: return "Abdominal Cramps"
        case .acne: return "Acne"
        case .appetiteChanges: return "Appetite Changes"
        case .bladderIncontinence: return "Bladder Incontinence"
        case .bloating: return "Bloating"
        case .breastPain: return "Breast Pain"
        case .chestTightnessOrPain: return "Chest Tightness or Pain"
        case .chills: return "Chills"
        case .constipation: return "Constipation"
        case .coughing: return "Coughing"
        case .diarrhea: return "Diarrhea"
        case .dizziness: return "Dizziness"
        case .drySkin: return "Dry Skin"
        case .fainting: return "Fainting"
        case .fatigue: return "Fatigue"
        case .fever: return "Fever"
        case .generalizedBodyAche: return "Body and Muscle Ache"
        case .hairLoss: return "Hair Loss"
        case .headache: return "Headache"
        case .heartburn: return "Heartburn"
        case .hotFlashes: return "Hot Flashes"
        case .lossOfSmell: return "Loss of Smell"
        case .lossOfTaste: return "Loss of Taste"
        case .lowerBackPain: return "Lower Back Pain"
        case .memoryLapse: return "Memory Lapse"
        case .moodChanges: return "Mood Changes"
        case .nausea: return "Nausea"
        case .nightSweats: return "Night Sweats"
        case .pelvicPain: return "Pelvic Pain"
        case .rapidPoundingOrFlutteringHeartbeat: return "Rapid, Pounding, or Fluttering Heartbeat"
        case .runnyNose: return "Runny Nose"
        case .shortnessOfBreath: return "Shortness of Breath"
        case .sinusCongestion: return "Congestion"
        case .skippedHeartbeat: return "Skipped Heartbeat"
        case .sleepChanges: return "Sleep Changes"
        case .soreThroat: return "Sore Throat"
        case .vaginalDryness: return "Vaginal Dryness"
        case .vomiting: return "Vomiting"
        case .wheezing: return "Wheezing"
        default: return identifier
        }
    }
}
