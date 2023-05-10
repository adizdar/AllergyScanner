//
//  HealthKitRequest.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 10.05.23.
//

import Foundation
import HealthKit

class HealthKitManager {
	let healthStore = HKHealthStore()

	func requestAuthorization() {
		let typesToShare: Set = [HKObjectType.categoryType(forIdentifier: .acne)!, HKObjectType.clinicalType(forIdentifier: .allergyRecord)!]

		healthStore.requestAuthorization(toShare: typesToShare, read: nil) { success, error in
			if let error = error {
				print("Error requesting authorization: \(error.localizedDescription)")
			} else {
				print("Authorization request succeeded")
			}
		}
	}
}
