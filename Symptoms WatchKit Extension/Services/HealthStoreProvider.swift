//
//  HealthStoreProvider.swift
//  Symptoms WatchKit Extension
//
//  Created by Leptos on 12/31/21.
//

import HealthKit

protocol HealthStoreProvider {
    func save(_ object: HKObject) async throws
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws
}

extension HealthStoreProvider {
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>) async throws {
        try await requestAuthorization(toShare: typesToShare, read: Set())
    }
    func requestAuthorization(toRead typesToRead: Set<HKObjectType>) async throws {
        try await requestAuthorization(toShare: Set(), read: typesToRead)
    }
}
