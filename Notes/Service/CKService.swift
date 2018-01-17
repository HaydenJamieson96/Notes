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
    
    func subscribe() {
        let subscription = CKQuerySubscription(recordType: Note.recordType, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        privateDatabase.save(subscription) { (sub, error) in
            print(error ?? "No CKSub error")
            print(sub ?? "Unable to subscribe")
        }
    }
    
    func subscribeWithUI() {
        let subscription = CKQuerySubscription(recordType: Note.recordType, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.title = "This is cool"
        notificationInfo.subtitle = "A whole new iCloud"
        notificationInfo.alertBody = "A bet you didn't know about the power of the cloud"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
        privateDatabase.save(subscription) { (sub, error) in
            print(error ?? "No CKSub error")
            print(sub ?? "Unable to subscribe")
        }
    }
    
    func fetchRecord(with recordId: CKRecordID) {
        privateDatabase.fetch(withRecordID: recordId) { (record, error) in
            print(error ?? "No CKFetch error")
            guard let record = record else {return}
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("internalNotification.fetchedRecord"), object: record)
            }
            
        }
    }
    
    func handleNotification(with userInfo: [AnyHashable: Any]) {
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        switch notification.notificationType {
        case .query:
            guard let queryNotification = notification as? CKQueryNotification, let recordId = queryNotification.recordID else {return}
            fetchRecord(with: recordId)
        default:
            return
        }
    }
    
}


