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
    
    enum ColumnCase: String {
        case filename = "Filename"
        case title = "Title"
        case artist = "Artist"
        case album = "Album"
        case track = "Track"
        case discnumber = "Discnumber"
        case year = "Year"
        case genre = "Genre"
        case composer = "Composer"
        case comment = "Comment"
        case albumArtist = "Album artist"
    }
    
    func columnChoice(for type: ColumnCase) -> String {
        switch type {
        case .filename:
            return "filename"
        case .title:
            return "title"
        case .artist:
            return "artist"
        case .album:
            return "album"
        case .track:
            return "track"
        case .discnumber:
            return "discnumber"
        case .year:
            return "year"
        case .genre:
            return "genre"
        case .composer:
            return "composer"
        case .comment:
            return "comment"
        case .albumArtist:
            return "albumArtist"
        }
    }
    
    let columns: [ColumnCase] = [
        .filename,
        .title,
        .artist,
        .album,
        .track,
        .discnumber,
        .year,
        .genre,
        .composer,
        .comment,
        .albumArtist
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
        return columns.count;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = columns[indexPath.row]
        let realm = try! Realm()
        let column = Column()
        try! realm.write {
            column.choice = columnChoice(for: type)
        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = columns[indexPath.row].rawValue
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        return cell
    }
}
