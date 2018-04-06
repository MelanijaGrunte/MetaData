//
//  SortFilesBy.swift
//  MetaData
//
//  Created by Melanija Grunte on 01/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import RealmSwift

class SortFilesBy: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var sortFilesByView: UIView!
    @IBOutlet weak var sortFilesByTableView: UITableView!
    
    enum SortField: String {
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
    
    func attributeChoice(for type: SortField) -> String {
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
    
    let attributes: [SortField] = [
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
        
        sortFilesByTableView.dataSource = self
        sortFilesByTableView.delegate = self
        sortFilesByTableView.layer.cornerRadius = 10
        sortFilesByTableView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count;
    }
    
    // MARK: actions
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let type = attributes[indexPath.row]
        let realm = try! Realm()
        let attribute = Attribute()
        try! realm.write {
            attribute.choice = attributeChoice(for: type)
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = attributes[indexPath.row].rawValue
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        return cell
    }
}
