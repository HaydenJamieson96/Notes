//
//  ViewController.swift
//  Notes
//
//  Created by Hayden Jamieson on 17/01/2018.
//  Copyright © 2018 Hayden Jamieson. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CKService.shared.subscribeWithUI()
        //CKService.shared.subscribe()
        UNService.shared.authorize()
        tableView.dataSource = self
        getNotes()
        NotificationCenter.default.addObserver(self, selector: #selector(handleFetch(_:)), name: NSNotification.Name("internalNotification.fetchedRecord"), object: nil)
    }
    
    func getNotes() {
        NoteService.getNotes { (notes) in
            self.notes = notes
            self.tableView.reloadData()
        }
    }

    @IBAction func onComposeTapped(_ sender: Any) {
        AlertService.composeNote(in: self) { (note) in
            CKService.shared.save(record: note.noteRecord())
            self.insert(note: note)
        }
    }
    
    func insert(note: Note) {
        notes.insert(note, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc
    func handleFetch(_ sender: Notification) {
        guard let record = sender.object as? CKRecord, let note = Note(record: record) else { return }
        insert(note: note)
    }

}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
}
