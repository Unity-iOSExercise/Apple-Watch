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
import Firebase

class ViewController: UIViewController {
    
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://sweat-to-safety.firebaseio.com/")
    var healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(healthStore!)
        authorizeHealthData()
        monitorHeartRate()
        println(healthStore!)
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // Authorize health data
    func authorizeHealthData() {
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
    }
    
    
    // Set up heart rate observer.
    func monitorHeartRate() {
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
    
    // Write data to Firebase
    func updateHeartRate() {
        self.myRootRef.setValue("Do you have data? You'll love Firebase.")
    }

}

