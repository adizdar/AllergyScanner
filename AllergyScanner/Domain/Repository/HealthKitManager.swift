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
		let typesToShare: Set = [
			HKObjectType.categoryType(forIdentifier: .acne)!,
			HKObjectType.categoryType(forIdentifier: .drySkin)!
		]

		healthStore.requestAuthorization(
			toShare: typesToShare, read: nil
		) { success, error in
			if let error = error {
				print("Error requesting authorization: \(error.localizedDescription)")
			} else {
				print("Authorization request succeeded")
			}
		}
	}

	func saveData(acneValue: Int, drySkinValue: Int) {
		let acneType = HKObjectType.categoryType(forIdentifier: .acne)!
		let drySkinType = HKObjectType.categoryType(forIdentifier: .drySkin)!
		let acneSample = HKCategorySample(type: acneType, value: acneValue, start: Date(), end: Date())
		let drySkinSample = HKCategorySample(type: drySkinType, value: drySkinValue, start: Date(), end: Date())

		healthStore.save([acneSample, drySkinSample]) { success, error in
			if let error = error {
				print("Error saving data: \(error.localizedDescription)")
			} else {
				print("Data saved successfully")
			}
		}
	}
}
