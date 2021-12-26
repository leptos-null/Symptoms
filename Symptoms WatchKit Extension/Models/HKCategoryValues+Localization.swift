//
//  HKCategoryValueSeverity+Localization.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/25/21.
//

import HealthKit

extension HKCategoryValueSeverity {
    var localizedName: String? {
        switch self {
        case .unspecified: return "Present"
        case .notPresent: return "Not Present"
        case .mild: return "Mild"
        case .moderate: return "Moderate"
        case .severe: return "Severe"
        @unknown default: return nil
        }
    }
}

extension HKCategoryValueAppetiteChanges {
    var localizedName: String? {
        switch self {
        case .unspecified: return "Present"
        case .noChange: return "No Change"
        case .decreased: return "Decreased"
        case .increased: return "Increased"
        @unknown default: return nil
        }
    }
}

extension HKCategoryValuePresence {
    var localizedName: String? {
        switch self {
        case .present: return "Present"
        case .notPresent: return "Not Present"
        @unknown default: return nil
        }
    }
}
