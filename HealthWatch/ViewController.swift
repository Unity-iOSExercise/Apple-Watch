//
//  ViewController.swift
//  HealthWatch
//
//  Created by Elizabeth Davis on 9/12/15.
//  Copyright (c) 2015 Elizabeth Davis. All rights reserved.
//

import Foundation

import HealthKit
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        // Authorize health data
        let healthStore: HKHealthStore? = {
            if HKHealthStore.isHealthDataAvailable() {
                return HKHealthStore()
            } else {
                return nil
            }
        }()
        
        let quantityTypesUsedInApp : NSArray = [HKQuantityTypeIdentifierBodyMass,
            HKQuantityTypeIdentifierHeight,
            HKQuantityTypeIdentifierBodyMassIndex,
            HKQuantityTypeIdentifierActiveEnergyBurned,
            HKQuantityTypeIdentifierDistanceWalkingRunning,
            HKQuantityTypeIdentifierHeartRate,
            HKCharacteristicTypeIdentifierBiologicalSex,
            HKCharacteristicTypeIdentifierDateOfBirth]
        
        var requestQuantityTypes = Set<HKQuantityType>()
        for identifier in quantityTypesUsedInApp {
            let quantityType : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(identifier as! String)
            let authorizationStatus : HKAuthorizationStatus = healthStore!.authorizationStatusForType(quantityType)
            if authorizationStatus != HKAuthorizationStatus.SharingAuthorized {
                requestQuantityTypes.insert(quantityType)
            }
        }
        
        healthStore!.requestAuthorizationToShareTypes(requestQuantityTypes, readTypes: nil) {
            success, error in
            if success == false {
                NSLog("Failed to authorize: \(error.description)")
            }
        }
        
        // Set up heart rate observer.
        let heartRateType =
        HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) {
            query, completionHandler, error in
            
            if error != nil {
                println("*** An error occured while setting up the heartRate observer. \(error.localizedDescription) ***")
                abort()
            }
            
            self.updateHeartRate()
            completionHandler()
        }
        
        healthStore!.executeQuery(query)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateHeartRate() {
    
    }

}

