//
//  HealthService.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/26/21.
//

import HealthKit

final class HealthService {
    static let shared = HealthService()
    
    private let healthStore = HKHealthStore()
    
    func save(_ object: HKObject) async throws {
        try await healthStore.save(object)
    }
    
    func requestAuthorization(toShare typesToShare: Set<HKSampleType> = Set(), read typesToRead: Set<HKObjectType> = Set()) async throws {
        try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
    }
}
