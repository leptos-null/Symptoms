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
    
    func save(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void) {
        healthStore.save(object, withCompletion: completion)
    }
    
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>? = nil, read typesToRead: Set<HKObjectType>? = nil, completion: @escaping (Bool, Error?) -> Void) {
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead, completion: completion)
    }
}
