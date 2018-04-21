//
//  SongTableViewController.swift
//  MetaData
//
//  Created by Melanija Grunte on 12/11/2017.
//  Copyright © 2017 Melanija Grunte. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class SongTableViewController: UITableViewController, UISearchBarDelegate, SongVCDelegate {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SongTableViewCell else {
            fatalError("The dequeued cell is not an instance of SongTableViewCell.")
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let song = displayedSongs[indexPath.row]
        let realm = try! Realm()
        let columnAttribute = realm.objects(Column.self)
        if let column = columnAttribute.last {
            cell.columnAttribute.textColor = UIColor.black
            cell.columnAttribute.text = song[column.choice] as? String
            if column.choice == "track" || column.choice == "discnumber" || column.choice == "year" {
                if let numberAttribute = song[column.choice] {
                    cell.columnAttribute.text = String(describing: numberAttribute)
                }
            }
            if cell.columnAttribute.text == nil {
                cell.columnAttribute.text = song.filename
                cell.columnAttribute.textColor = UIColor(white: 0.75, alpha:1)
            }
        } else {
            cell.columnAttribute.text = song.filename
        }
        if song.albumArtImage != nil {
            cell.albumArtImage?.image = UIImage(data: song.albumArtImage!)
        } else {
            cell.albumArtImage.image = UIImage(named: "defaultnoalbumart")
        }
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        let segueChoice = realm.objects(SegueIdentifier.self)
        let seg = segueChoice.last
        if seg?.identifier == "segueToNextSongVC" {
            super.viewWillAppear(animated)
            self.tableView.reloadData()
        }
    }

    // MARK: Searchbar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchQuery = searchBar.text, !searchQuery.isEmpty {
            let realm = try! Realm()
            let template = NSPredicate(format: "filename CONTAINS[c] $SRCH OR title CONTAINS[c] $SRCH OR album CONTAINS[c] $SRCH OR artist CONTAINS[c] $SRCH OR composer CONTAINS[c] $SRCH OR comment CONTAINS[c] $SRCH")
            let subVars = ["SRCH": searchQuery]
            let predicate = template.withSubstitutionVariables(subVars)
            let songs = realm.objects(Song.self).filter(predicate)
            let attribute = realm.objects(Attribute.self)
            if let attr = attribute.last {
                displayedSongs = songs.sorted(by: [SortDescriptor(keyPath: attr.choice, ascending: true), "filename"])
            } else {
                displayedSongs = songs.sorted(byKeyPath: "filename")
            }
        }
        if searchText == "" {
            loadSampleSongs()
        }
        self.tableView.reloadData()
    }
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
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
            songDetailViewController.delegate = self
        default: ()
        }
    }
    
    //MARK: Actions
    
    func didFinishSongVC(controller: SongViewController) {
        if let sourceViewController = controller as? SongViewController, let song = sourceViewController.song {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                var array = Array(displayedSongs)
                array[selectedIndexPath.row] = song
                loadSampleSongs()
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
    }
    
    ///MARK: Private Methods
    
    private func loadSampleSongs() {
        let realm = try! Realm()
        let songs = realm.objects(Song.self)
        let attribute = realm.objects(Attribute.self)
        if let attr = attribute.last {
            displayedSongs = songs.sorted(by: [SortDescriptor(keyPath: attr.choice, ascending: true), "filename"])
        } else {
            displayedSongs = songs.sorted(byKeyPath: "filename")
        }
        self.tableView.reloadData()
    }
}
