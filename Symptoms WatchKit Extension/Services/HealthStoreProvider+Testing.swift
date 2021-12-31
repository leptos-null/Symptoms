//
//  HealthStoreProvider+Testing.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/31/21.
//

import HealthKit

struct AcceptHealthStore: HealthStoreProvider {
    static let fast = Self(nanosecondDelay: 1_000)
    static let slow = Self(nanosecondDelay: 1_000_000_000) // 1 second
    
    let nanosecondDelay: UInt64
    
    func save(_ object: HKObject) async throws {
        try await Task.sleep(nanoseconds: nanosecondDelay)
    }
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws {
        try await Task.sleep(nanoseconds: nanosecondDelay)
    }
}

struct FailureHealthStore: HealthStoreProvider {
    struct Unavoidable: LocalizedError {
        var errorDescription: String? = "A code path was intentionally selected to result in an error"
    }
    
    static let fast = Self(nanosecondDelay: 1_000)
    static let slow = Self(nanosecondDelay: 1_000_000_000) // 1 second
    
    let nanosecondDelay: UInt64
    
    func save(_ object: HKObject) async throws {
        try await Task.sleep(nanoseconds: nanosecondDelay)
        throw Unavoidable()
    }
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws {
        try await Task.sleep(nanoseconds: nanosecondDelay)
        throw Unavoidable()
    }
}
