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
    @IBOutlet weak var separation: UITextField!
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
            return "{titleDescription}"
        case .artist:
            return "{artistDescription}"
        case .album:
            return "{albumDescription}"
        case .track:
            return "{trackDescription}"
        case .discnumber:
            return "{discnumberDescription}"
        case .year:
            return "{yearDescription}"
        case .genre:
            return "{genreDescription}"
        case .composer:
            return "{composerDescription}"
        case .comment:
            return "{commentDescription}"
        case .albumArtist:
            return "{albumArtistDescription}"
        }
    }
    
    let tags: [CheckBoxes] = [.title, .artist, .album, .track, .discnumber, .year, .genre, .composer, .comment, .albumArtist]

    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        separation.delegate = self

        unknownTagReplacement.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        customReplacement.delegate = self
        customReplacement.returnKeyType = UIReturnKeyType.done
        customReplacement.addTarget(self, action: #selector(CustomFormatString.textFieldDidChange(_:)),
                                    for: UIControlEvents.editingChanged)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


        if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = tagCollectionView.bounds.width / 3.0
            var itemHeight = layout.itemSize.height
            if UIScreen.main.bounds.size.height == 568 {
                itemHeight = 34
            }
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }

    @IBAction func unknownTagReplacement(_ sender: UIButton) {
        unknownTagReplacement.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nothingReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        noReplacementSelection.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.systemFont(ofSize: 15)
        customReplacement.text = nil

        let customFormatStringStyle = realm.objects(CustomFormatStringStyle.self)
        try! realm.write {
            customFormatStringStyle.setValue("unknown", forKeyPath: "tagReplacement")
        }
    }
    
    @IBAction func nothingReplacement(_ sender: UIButton) {
        nothingReplacement.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        unknownTagReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        noReplacementSelection.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.systemFont(ofSize: 15)
        customReplacement.text = nil

        let customFormatStringStyle = realm.objects(CustomFormatStringStyle.self)
        try! realm.write {
            customFormatStringStyle.setValue("empty", forKeyPath: "tagReplacement")
        }
    }
    
    @IBAction func noReplacementSelection(_ sender: UIButton) {
        noReplacementSelection.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nothingReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        unknownTagReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.systemFont(ofSize: 15)
        customReplacement.text = nil

        let customFormatStringStyle = realm.objects(CustomFormatStringStyle.self)
        try! realm.write {
            customFormatStringStyle.setValue("unchanged filename", forKeyPath: "tagReplacement")
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        self.customReplacement.text = customReplacement.text ?? nil
        nothingReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        unknownTagReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        noReplacementSelection.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.boldSystemFont(ofSize: 15)

        let customFormatStringStyle = realm.objects(CustomFormatStringStyle.self)
        try! realm.write {
            customFormatStringStyle.setValue(customReplacement.text!, forKeyPath: "tagReplacement")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomFormatStringTagCell
        cell.tagLabel.text = tags[indexPath.row].rawValue
        let type = tags[indexPath.row]
        cell.cellValue = tagChoice(for: type)

        if UIScreen.main.bounds.size.width == 375 { // iPhone X ; iPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6
            if UIScreen.main.bounds.size.height == 812 {
                cell.tagLabel.font = UIFont.systemFont(ofSize: 15.0)
            } else {
                cell.tagLabel.font = UIFont.systemFont(ofSize: 14.0) }
        } else if UIScreen.main.bounds.size.width == 414 { // IPhone 8 Plus ; iPhone 7 Plus
            cell.tagLabel.font = UIFont.systemFont(ofSize: 15.0)
//            cell.checkbox.frame.size.height = 13
//            cell.checkbox.frame.size.width = 13
//            cell.checkbox.frame = CGRect(x: 0, y: 0, width: 13, height: 13)
        } else if UIScreen.main.bounds.size.width == 320 { // iPhone SE
            cell.tagLabel.font = UIFont.systemFont(ofSize: 13.0)
//            cell.frame.width. = 60
//                        cell.checkbox.frame.size.height = 10
//                        cell.checkbox.frame.size.width = 10
//
//            cell.checkbox.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        }

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
    }
    
    func createFormatString () {
        let customFormatStringStyle = realm.objects(CustomFormatStringStyle.self)
        if chosenTags.count > 0 {
            var result = "\(chosenTags[0])"
            for element in 1..<chosenTags.count {
                let repeatingString = " \(separation.text!) \(chosenTags[element])"
                result = result + repeatingString
            }
            try! realm.write {
                customFormatStringStyle.setValue(result, forKeyPath: "stringStyle")
            }
            if separation.text != "" {
                try! realm.write {
                    customFormatStringStyle.setValue(separation.text!, forKeyPath: "separationText")
                }
            } else {
                try! realm.write {
                    customFormatStringStyle.setValue(" ", forKeyPath: "separationText")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        createFormatString ()

//        try! realm.write {
//            realm.add(customFormatStringStyle)
//        }

        var fileRenamingChoice: Results<FileRenamingChoice> //////////////
        fileRenamingChoice = realm.objects(FileRenamingChoice.self) //////////////
        let format = fileRenamingChoice.last

        var customFormatStringStyle: Results<CustomFormatStringStyle> //////////////
        customFormatStringStyle = realm.objects(CustomFormatStringStyle.self) //////////////
        let style = customFormatStringStyle.last

        if format?.chosenTag == 8 {
            try! realm.write {
                fileRenamingChoice.setValue(style?.stringStyle, forKey: "chosenStyle")
            }
        }

        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return }
    }
}
