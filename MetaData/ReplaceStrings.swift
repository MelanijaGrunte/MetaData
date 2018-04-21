//
//  ReplaceStrings.swift
//  MetaData
//
//  Created by Melanija Grunte on 02/03/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class ReplaceStrings: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var stringToBeReplacedText: UITextField!
    @IBOutlet weak var stringReplacementText: UITextField!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var caseSensitive: UIButton!
    @IBOutlet weak var caseSensitiveCheckbox: UIImageView!
    @IBOutlet weak var caseInstensitive: UIButton!
    @IBOutlet weak var caseInsensitiveCheckbox: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var caseSelection: NSString.CompareOptions = .literal
    var array: Array = [String]()
    
    enum CheckBoxes: String {
        case filename = "filename"
        case title = "title"
        case artist = "artist"
        case album = "album"
        case track = "track"
        case discnumber = "discnumber"
        case year = "year"
        case genre = "genre"
        case composer = "composer"
        case comment = "comment"
        case albumArtist = "album artist"
        case allTags = "SELECT ALL"
    }
    
    func tagChoice() {
        let intToBeReplaced = Int(stringToBeReplacedText.text!)
        let intReplacementText = Int(stringReplacementText.text!)
        
        let realm = try! Realm()
        
        try! realm.write {
            for songs in realm.objects(Song.self) {
                for i in 0..<array.count {
                    switch array[i] {
                    case "filename":
                        songs.filename = songs.filename.replacingOccurrences(of: stringToBeReplacedText.text!, with: stringReplacementText.text!, options: caseSelection)
                    case "title":
                        songs.title = songs.title?.replacingOccurrences(of: stringToBeReplacedText.text!, with: stringReplacementText.text!, options: caseSelection)
                    case "artist":
                        songs.artist = songs.artist?.replacingOccurrences(of: stringToBeReplacedText.text!, with: stringReplacementText.text!, options: caseSelection)
                    case "album":
                        songs.album = songs.album?.replacingOccurrences(of: stringToBeReplacedText.text!, with: stringReplacementText.text!, options: caseSelection)
                    case "track":
                        if intToBeReplaced != nil && intReplacementText != nil && songs.track.value == intToBeReplaced {
                            songs.track.value = intReplacementText
                        }
                    case "discnumber":
                        if intToBeReplaced != nil && intReplacementText != nil && songs.discnumber.value == intToBeReplaced {
                            songs.discnumber.value = intReplacementText
                        }
                    case "year":
                        if intToBeReplaced != nil && intReplacementText != nil && songs.year.value == intToBeReplaced {
                            songs.year.value = intReplacementText
                        }
                    case "genre":
                        songs.genre = songs.genre?.replacingOccurrences(of: stringToBeReplacedText.text!, with: stringReplacementText.text!, options: caseSelection)
                    case "composer":
                        songs.composer = songs.composer?.replacingOccurrences(of: stringToBeReplacedText.text!, with: stringReplacementText.text!, options: caseSelection)
                    case "comment":
                        songs.comment = songs.comment?.replacingOccurrences(of: stringToBeReplacedText.text!, with: stringReplacementText.text!, options: caseSelection)
                    case "album artist":
                        songs.albumArtist = songs.albumArtist?.replacingOccurrences(of: stringToBeReplacedText.text!, with: stringReplacementText.text!, options: caseSelection)
                    default:
                        ()
                    }}}}}
    
    let tags: [CheckBoxes] = [.filename, .title, .artist, .album, .track, .discnumber, .year, .genre, .composer, .comment, .albumArtist, .allTags]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stringToBeReplacedText.delegate = self
        stringReplacementText.delegate = self
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        caseSensitive.addTarget(self, action: #selector(ReplaceStrings.caseSensitive(_:)), for: .touchUpInside)
        caseInstensitive.addTarget(self, action: #selector(ReplaceStrings.caseInsensitive(_:)), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = tagCollectionView.bounds.width / 3.0
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReplaceStringsTagCell
        cell.tagLabel.text = tags[indexPath.row].rawValue

        if UIScreen.main.bounds.size.width == 375 { // iPhone X ; iPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6
            if UIScreen.main.bounds.size.height == 812 {
                cell.tagLabel.font = UIFont.systemFont(ofSize: 15.0)
            } else {
                cell.tagLabel.font = UIFont.systemFont(ofSize: 14.0) }
        } else if UIScreen.main.bounds.size.width == 414 { // IPhone 8 Plus ; iPhone 7 Plus
            cell.tagLabel.font = UIFont.systemFont(ofSize: 15.0)

        } else if UIScreen.main.bounds.size.width == 320 { // iPhone SE
            cell.tagLabel.font = UIFont.systemFont(ofSize: 13.0) }

        return cell
    }
    
    @IBAction func caseSensitive(_ sender: UIButton) {
        caseSensitiveCheckbox.image = UIImage(named:"checkedCase")
        caseInsensitiveCheckbox.image = UIImage(named:"uncheckedCase")
        caseSelection = .literal
    }
    
    @IBAction func caseInsensitive(_ sender: UIButton) {
        caseInsensitiveCheckbox.image = UIImage(named:"checkedCase")
        caseSensitiveCheckbox.image = UIImage(named:"uncheckedCase")
        caseSelection = .caseInsensitive
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath) as! ReplaceStringsTagCell
        if array.contains(cell.tagLabel.text!) == false {
            if cell.tagLabel.text == "SELECT ALL" {
                array = ["filename", "title", "artist", "album", "track", "discnumber", "year", "genre", "composer", "comment", "album artist", "SELECT ALL"]
                for all in 0..<12 {
                    let allCells = tagCollectionView.cellForItem(at: IndexPath(row: all, section: 0)) as! ReplaceStringsTagCell
                    allCells.checkbox.image = UIImage(named: "checked")
                }
                cell.tagLabel.text = "SELECT ALL"
            }
            else {
                array.append(cell.tagLabel.text!)
                cell.checkbox.image = UIImage(named: "checked")
            }
        }
        else {
            if cell.tagLabel.text == "SELECT ALL" {
                array.removeAll()
                for all in 0..<12 {
                    let allCells = tagCollectionView.cellForItem(at: IndexPath(row: all, section: 0)) as! ReplaceStringsTagCell
                    allCells.checkbox.image = UIImage(named: "unchecked")
                }
            }
            else {
                let index = array.index(of: cell.tagLabel.text!)
                array.remove(at: index!)
                cell.checkbox.image = UIImage(named: "unchecked")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        tagChoice()
        
        guard let button = sender as? UIBarButtonItem, button === doneButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return }
    }
}
