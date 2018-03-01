//
//  SelectFormatString.swift
//  MetaData
//
//  Created by Melanija Grunte on 01/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class SelectFormatString: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var selectFormatStringView: UIView!
    @IBOutlet weak var selectFormatStringTableView: UITableView!

    enum filenameType: String {
        case artistAlbumTrackTitle = "artist - album - track - title"
        case artistAlbumTitle = "artist - album - title"
        case artistTitle = "artist - title"
        case albumTrackTitle = "album - track - title"
        case albumTitle = "album - title"
        case trackTitle = "track - title"
        case title = "title"
        case artistTrackAlbum = "artitst - track - album"
    }

    func filenameString(for type: filenameType, song: Song) -> String {
        switch type {
        case .artistAlbumTrackTitle:
            return "\(song.artistDescription) - \(song.albumDescription) - \(song.trackDescription) - \(song.titleDescription)"
        case .artistAlbumTitle:
            return "\(song.artistDescription) - \(song.albumDescription) - \(song.titleDescription)"
        case .artistTitle:
            return "\(song.artistDescription) - \(song.titleDescription)"
        case .albumTrackTitle:
            return "\(song.albumDescription) - \(song.trackDescription) - \(song.titleDescription)"
        case .albumTitle:
            return "\(song.albumDescription) - \(song.titleDescription)"
        case .trackTitle:
            return "\(song.trackDescription) - \(song.titleDescription)"
        case .title:
            return "\(song.titleDescription)"
        case .artistTrackAlbum:
            return "\(song.artistDescription) - \(song.trackDescription) - \(song.albumDescription)"
        }
    }

    let types: [filenameType] = [
        .artistAlbumTrackTitle,
        .artistAlbumTitle,
        .artistTitle,
        .albumTrackTitle,
        .albumTitle,
        .trackTitle,
        .title,
        .artistTrackAlbum
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

    navigationController?.popViewController(animated: true)
    selectFormatStringTableView.dataSource = self
    selectFormatStringTableView.delegate = self
    selectFormatStringTableView.layer.cornerRadius = 10
    selectFormatStringTableView.layer.masksToBounds = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count;
    }

    // MARK: actions

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = types[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            for songs in realm.objects(Song.self) {
                songs.filename = filenameString(for: type, song: songs)
                }
            }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = types[indexPath.row].rawValue
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        return cell
    }
}

