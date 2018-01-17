//
//  AlertService.swift
//  Notes
//
//  Created by Hayden Jamieson on 17/01/2018.
//  Copyright © 2018 Hayden Jamieson. All rights reserved.
//

import UIKit

class AlertService {
    
    private init() {}
    
    static func composeNote(in vc: UIViewController, completion: @escaping (Note) -> Void ) {
        let alert = UIAlertController(title: "New Note", message: "What's on your mind?", preferredStyle: .alert)
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Title"
        }
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let title = alert.textFields?.first?.text else { return }
            let note = Note(title: title)
            completion(note)
        }
        alert.addAction(post)
        vc.present(alert, animated: true, completion: nil)
    }
    
}
