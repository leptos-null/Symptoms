//
//  HealthService.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/26/21.
//

import HealthKit

final class HealthService {
    static let shared = HealthService()
    
    let healthStore = HKHealthStore()
}
