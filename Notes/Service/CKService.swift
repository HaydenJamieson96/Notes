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
    
}


