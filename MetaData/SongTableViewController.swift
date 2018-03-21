import RealmSwift

//
//  SongTableViewController.swift
//  MetaData
//
//  Created by Melanija Grunte on 12/11/2017.
//  Copyright © 2017 Melanija Grunte. All rights reserved.
//

import UIKit
import os.log

class SongTableViewController: UITableViewController, UISearchBarDelegate {

    //MARK: Properties

    @IBOutlet weak var searchBar: UISearchBar!

    let realm = try! Realm()
    var songs = [Song]()
    var displayedSongs: Results<Song>!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleSongs()

        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done

//        navigationItem.hidesSearchBarWhenScrolling = false

        self.tableView.reloadData()
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return displayedSongs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SongTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SongTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SongTableViewCell.")
        }
        let song = displayedSongs[indexPath.row]
        cell.filename.text = song.filename
        if song.albumArtImage != nil {
            cell.albumArtImage?.image = UIImage(data: song.albumArtImage!)}
        else { cell.albumArtImage.image = UIImage(named: "defaultnoalbumart")}
        return cell
    }

    // MARK: Sorting

    // searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchQuery = searchBar.text, !searchQuery.isEmpty {
            let realm = try! Realm()
            let template = NSPredicate(format: "filename CONTAINS[c] $SRCH OR title CONTAINS[c] $SRCH OR album CONTAINS[c] $SRCH OR artist CONTAINS[c] $SRCH OR composer CONTAINS[c] $SRCH OR comment CONTAINS[c] $SRCH")
            let subVars = ["SRCH": searchQuery]
            let predicate = template.withSubstitutionVariables(subVars)
            let songs = realm.objects(Song.self).filter(predicate)
            var attribute: Results<Attribute>?
            attribute = realm.objects(Attribute.self)
            if let attr = attribute?.last {
                displayedSongs = songs.sorted(by: [SortDescriptor(keyPath: attr.choice, ascending: true)])
            } else {
                displayedSongs = songs.sorted(byKeyPath: "filename")
            }
        }
        if searchText == "" {
            // ja nospiezh x
            searchBar.endEditing(true)      // ir taa stulbaa zilaa mirgojoshaa liinija
            // searchBarShouldEndEditing(searchBar)
            loadSampleSongs()
        }
        self.tableView.reloadData()
    }

    @IBAction func searchButton(_ sender: UIBarButtonItem) {
//        presentViewController(searchController, animated: true, completion: nil)
        tableView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)   ///// mooooore!
    }


// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "ShowDetail":
            guard let songDetailViewController = segue.destination as? SongViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedSongCell = sender as? SongTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedSongCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedSong = displayedSongs[indexPath.row]
            songDetailViewController.song = selectedSong

            songDetailViewController.tableSongs = displayedSongs
            songDetailViewController.selectedIndex = indexPath.row
            songDetailViewController.song = displayedSongs[indexPath.row]

        default: ()
        }
    }

    //MARK: Actions

    // rediģētās dziesmas aizstāšana ar veco versiju
//    func unwindToSongList(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? SongViewController, let song = sourceViewController.song {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                let oldSong = displayedSongs[selectedIndexPath.row]
//                if let index = songs.index(where: { song -> Bool in
//                    return song == oldSong
//                }) {
//                    songs[index] = song
//                }
////                var array = Array(displayedSongs)
////                array[selectedIndexPath.row] = song
//                //displayedSongs[selectedIndexPath.row] = song
//
//                // šis lkm ruins to, ka ejot no dziesmas editoshanas uzlec liidz pashai aughsai
//                loadSampleSongs()
//                tableView.reloadRows(at: [selectedIndexPath], with: .none)
//            }
//        }
//    }

    @IBAction func unwindToSongTableView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SongViewController, let song = sourceViewController.song {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let oldSong = displayedSongs[selectedIndexPath.row]
                if let index = songs.index(where: { song -> Bool in
                    return song == oldSong
                }) {
                    songs[index] = song
                }
                //                var array = Array(displayedSongs)
                //                array[selectedIndexPath.row] = song
                //displayedSongs[selectedIndexPath.row] = song

                // šis lkm ruins to, ka ejot no dziesmas editoshanas uzlec liidz pashai aughsai
                loadSampleSongs()
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
    }

    ///MARK: Private Methods

    private func loadSampleSongs() {
        let realm = try! Realm()
        let songs = realm.objects(Song.self)

        var attribute: Results<Attribute>?
        attribute = realm.objects(Attribute.self)
        if let attr = attribute?.last {
            displayedSongs = songs.sorted(by: [SortDescriptor(keyPath: attr.choice, ascending: true)])
        } else {
            displayedSongs = songs.sorted(byKeyPath: "filename")
        }

        self.tableView.reloadData()
    }
}
