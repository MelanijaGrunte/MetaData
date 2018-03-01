//
//  AdjustColumnVisibility.swift
//  MetaData
//
//  Created by Melanija Grunte on 09/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import RealmSwift

class AdjustColumnVisibility: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var adjustColumnVisibilityView: UIView!
    @IBOutlet weak var adjustColumnVisibilityTableView: UITableView!

    let columnSets: [String] = [
        "file name",
        "title",
        "artist",
        "track",
        "year",
        "genre",
        "composer",
        "comment",
        "album art image",
        "album art artist"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.popViewController(animated: true)
        adjustColumnVisibilityTableView.dataSource = self
        adjustColumnVisibilityTableView.delegate = self
        adjustColumnVisibilityTableView.layer.cornerRadius = 10
        adjustColumnVisibilityTableView.layer.masksToBounds = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return columnSets.count;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            print("good day")

        case 1:
            print("whats up")

        case 2:
            print("wazaaa")

        case 3:
            print("hi")

        case 4:
            print("yo")

        case 5:
            print("hello")

        case 6:
            print("howdy")

        case 7:
            print("sup")

        case 8:
            print("...")

        case 9:
            print("g'day")

        default:
            print("bye")
        }
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = columnSets[indexPath.row]
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        return cell
    }
}
