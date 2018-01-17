//
//  NoteService.swift
//  Notes
//
//  Created by Hayden Jamieson on 17/01/2018.
//  Copyright © 2018 Hayden Jamieson. All rights reserved.
//

import Foundation

class NoteService {
    
    private init() {}
    
    static func getNotes(completion: @escaping ([Note]) -> () ) {
        CKService.shared.query(recordType: Note.recordType) { (records) in
            var notes = [Note]()
            for record in records {
                guard let note = Note(record: record) else { continue }
                notes.append(note)
            }
            completion(notes)
        }
    }
}
