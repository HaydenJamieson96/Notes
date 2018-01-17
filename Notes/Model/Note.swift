//
//  Note.swift
//  Notes
//
//  Created by Hayden Jamieson on 17/01/2018.
//  Copyright © 2018 Hayden Jamieson. All rights reserved.
//

import Foundation
import CloudKit

struct Note {
    
    static let recordType = "Note"
    let title: String
    
    func noteRecord() -> CKRecord {
        let record = CKRecord(recordType: Note.recordType)
        record.setValue(title, forKey: "title")
        return record
    }
}
