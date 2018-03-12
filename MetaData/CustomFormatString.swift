//
//  CustomFormatString.swift
//  MetaData
//
//  Created by Melanija Grunte on 02/03/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class CustomFormatString: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var seperation: UITextField!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var unknownTagReplacement: UIButton!
    @IBOutlet weak var nothingReplacement: UIButton!
    @IBOutlet weak var noReplacementSelection: UIButton!
    @IBOutlet weak var customReplacement: UITextField!
    @IBOutlet weak var customLabel: UILabel!

    var chosenTags: Array = [String]()

    enum CheckBoxes: String {
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
    }

    func tagChoice(for type: CheckBoxes) -> String {
        switch type {
        case .title:
            return "\\(song.titleDescription)"
        case .artist:
            return "\\(song.artistDescription)"
        case .album:
            return "\\(song.albumDescription)"
        case .track:
            return "\\(song.trackDescription)"
        case .discnumber:
            return "\\(song.discnumberDescription)"
        case .year:
            return "\\(song.yearDescription)"
        case .genre:
            return "\\(song.genreDescription)"
        case .composer:
            return "\\(song.composerDescription)"
        case .comment:
            return "\\(song.commentDescription)"
        case .albumArtist:
            return "\\(song.albumArtistDescription)"
        }
    }

    let tags: [CheckBoxes] = [.title, .artist, .album, .track, .discnumber, .year, .genre, .composer, .comment, .albumArtist]

    override func viewDidLoad() {
        super.viewDidLoad()

        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self

        seperation.delegate = self

        customReplacement.delegate = self
        customReplacement.returnKeyType = UIReturnKeyType.done
        customReplacement.addTarget(self, action: #selector(CustomFormatString.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
    }

    @IBAction func unknownTagReplacement(_ sender: UIButton) {
        unknownTagReplacement.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nothingReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        noReplacementSelection.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.systemFont(ofSize: 15)
        customReplacement.text = nil
    }

    @IBAction func nothingReplacement(_ sender: UIButton) {
        nothingReplacement.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        unknownTagReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        noReplacementSelection.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.systemFont(ofSize: 15)
        customReplacement.text = nil
    }

    @IBAction func noReplacementSelection(_ sender: UIButton) {
        noReplacementSelection.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nothingReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        unknownTagReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.systemFont(ofSize: 15)
        customReplacement.text = nil
    }


    @IBAction func textFieldDidChange(_ sender: UITextField) {
            self.customReplacement.text = customReplacement.text ?? nil
            nothingReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            unknownTagReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            noReplacementSelection.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            customLabel.font = UIFont.boldSystemFont(ofSize: 15)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomFormatStringTagCell
        cell.tagLabel.text = tags[indexPath.row].rawValue
        let type = tags[indexPath.row]
        cell.cellValue = tagChoice(for: type)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath) as! CustomFormatStringTagCell

        if chosenTags.contains(cell.cellValue) == false {
            chosenTags.append(cell.cellValue)
        } else {
            let index = chosenTags.index(of: cell.cellValue)
            chosenTags.remove(at: index!)
            cell.checkbox.image = UIImage(named: "empty")
        }

        for row in 0..<10 {
            for element in 0..<chosenTags.count {
                let allCells = tagCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as! CustomFormatStringTagCell
                if chosenTags[element] == allCells.cellValue {
                    allCells.checkbox.image = UIImage(named: "\(element+1)")
                }
            }
        }
        print(chosenTags)
    }

    func createFormatString () {
        // tur būs tā, ka būs --- return array[element] un + " \(izvēlētais strings) \(array[element])" <- tik daudz, cik ir array elementu -1
        // bet tas array elements ir jāsavieno ar bla bla bla description
        // ja izvēlēts unknown tag, tad ņem no Song
        // ja izvēlēts kkas cits, tad vai nu empty vai arī ievietotais tas
        // tātad, kur ir array[element] tur būs ?? customThang !!!
        // jāsadarbojas ar SelectFormatString D:

        // ja ir izvēlēts "nothing" kā custom string, tad jābūt mazāk seperationiem!

        // visticamāk jāievieto realmā šis lai select formatstring to varētu izmantot

        // un tad kad nav seperation, tad ir divas atstarpes. vai lietotājs gribētu, ka tā ir? hmm
        let realm = try! Realm()
        let customFormatString = CustomFormatStringStyle()
        var result = "\(chosenTags[0])"
        for element in 1..<chosenTags.count {
            let repeatingString = " \(seperation.text!) \(chosenTags[element])"
            result = result + repeatingString
        }

        customFormatString.stringStyle = result
        try! realm.write {
            realm.add(customFormatString)
        }
        print(result)

        // if one of the songs attributes are unknown, don't change the filename at all
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        createFormatString ()

        let realm = try! Realm()
        var customFormatString: Results<CustomFormatStringStyle>?
        customFormatString = realm.objects(CustomFormatStringStyle.self)
        let style = customFormatString?.last
        print(style!.stringStyle)

        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return }
    }
}


