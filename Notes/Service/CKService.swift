//
//  CKService.swift
//  Notes
//
//  Created by Hayden Jamieson on 17/01/2018.
//  Copyright © 2018 Hayden Jamieson. All rights reserved.
//

import Foundation
import CloudKit

class CKService {
    
    private init() {}
    
    static let shared = CKService()
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func save(record: CKRecord) {
        privateDatabase.save(record) { (record, error) in
            print(error ?? "No CKSaveError")
            print(record ?? "No CKRecord saved")
        }
    }
    
    func query(recordType: String, completion: @escaping ([CKRecord]) -> () ) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            print(error ?? "No CKQuery error")
            guard let records = records else {return}
            DispatchQueue.main.async {
                completion(records)
            }
            
        }
    }
    
}


