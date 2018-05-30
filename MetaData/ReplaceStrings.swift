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

    // piešķir vērtības atribūtu tipiem to ērtai lasīšanai
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
        // skaitlisko vērtību apstrādes gadījumam, izveido mainīgos, kas palīdz aizstāt skaistliskos metadatus ņemot to pilno vērtību nevis daļu
        let intToBeReplaced = Int(stringToBeReplacedText.text!)
        let intReplacementText = Int(stringReplacementText.text!)
        
        let realm = try! Realm()

        // katrā no lietotāja izvēlētajiem atribūtiem tiek aizstāts meklētais teksts ar laboto tekstu, ievērojot lielo-mazo burtu ievērošanas izvēli
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
                    // ja skaitliskā vērtība metadatam ir tieši tāda pati, kā vērtība, ko lietotājs vēlas aizstāt, tad tas tiek izdarīts
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

    // izveido atribūtu tipu vērtības
    let tags: [CheckBoxes] = [.filename, .title, .artist, .album, .track, .discnumber, .year, .genre, .composer, .comment, .albumArtist, .allTags]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // teksta lauciņi iegūst tā satura izmaiņas
        stringToBeReplacedText.delegate = self
        stringReplacementText.delegate = self

        // iegūst kolekcijas skata datus un padod tam satura izmaiņas
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self

        // pogām dod uztveri, ka tām ir veikts pieskāriens, lai palaistu nepieciešamās funkcijas
        caseSensitive.addTarget(self, action: #selector(ReplaceStrings.caseSensitive(_:)), for: .touchUpInside)
        caseInstensitive.addTarget(self, action: #selector(ReplaceStrings.caseInsensitive(_:)), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            // piešķir atribūtu izvēlnes skata šūnām platumu (kas tiek dalīts 3 vienādās ekrāna daļās) un augstumu (atkarībā no ierīces ekrāna augstuma)
            let itemWidth = tagCollectionView.bounds.width / 3.0
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }

    // izveido atribūtu izvēlnē tik vienības, cik ir atribūtu tipi
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    // kā atribūtu izvēlnes skata šūnas tiek iestatītas ReplaceStringsTagCell šūnas un to uzrakstiem tiek iestatīti atribūtu nosaukumi
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReplaceStringsTagCell
        cell.tagLabel.text = tags[indexPath.row].rawValue

        // šūnu uzrakstiem tiek mainīts teksta izmērs atkarībā no ierīces ekrāna platuma un augstuma
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

    // lietotājam pieskaroties pogai "case sensitive", tai tiek iestatīts ieķeksētas kastītes attēls, "case insensitive" pogas attēlam tiek iestatīts tukšs kastītes attēls un tiek saglabāta lietotāja izvēle ievērot lielos un mazos burtus
    @IBAction func caseSensitive(_ sender: UIButton) {
        caseSensitiveCheckbox.image = UIImage(named:"checkedCase")
        caseInsensitiveCheckbox.image = UIImage(named:"uncheckedCase")
        caseSelection = .literal
    }

    // lietotājam pieskaroties pogai "case insensitive", tai tiek iestatīts ieķeksētas kastītes attēls, "case sensitive" pogas attēlam tiek iestatīts tukšs kastītes attēls un tiek saglabāta lietotāja izvēle neievērot lielos un mazos burtus
    @IBAction func caseInsensitive(_ sender: UIButton) {
        caseInsensitiveCheckbox.image = UIImage(named:"checkedCase")
        caseSensitiveCheckbox.image = UIImage(named:"uncheckedCase")
        caseSelection = .caseInsensitive
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath) as! ReplaceStringsTagCell
        // ja atribūtu masīvā vēl neietilpst atribūts, kura šūnai lietotājs tikko veica pieskārienu
        if array.contains(cell.tagLabel.text!) == false {
            // ja lietotājs veica pieskārienu šūnai "SELECT ALL"
            if cell.tagLabel.text == "SELECT ALL" {
                // tad atribūta masīvā tiek ielikti visi atribūti
                array = ["filename", "title", "artist", "album", "track", "discnumber", "year", "genre", "composer", "comment", "album artist", "SELECT ALL"]
                // un tiem tiek uzstatīts ieķeksētas kastītes attēls
                for all in 0..<12 {
                    let allCells = tagCollectionView.cellForItem(at: IndexPath(row: all, section: 0)) as! ReplaceStringsTagCell
                    allCells.checkbox.image = UIImage(named: "checked")
                }
            }
            // ja lietotājs veica pieskārienu kādai citai šūnai (nevis "SELECT ALL")
            else {
                // tad attiecīgās šūnas atribūtu pievieno masīvam un to uzrāda kā atķeksētu
                array.append(cell.tagLabel.text!)
                cell.checkbox.image = UIImage(named: "checked")
            }
        }
        // ja atribūtu masīvā jau ietilpst atribūts, kura šūnai lietotājs tikko veica pieskārienu
        else {
            // ja lietotājs veica pieskārienu šūnai "SELECT ALL"
            if cell.tagLabel.text == "SELECT ALL" {
                // tad atribūtu masīvu iztīra
                array.removeAll()
                for all in 0..<12 {
                // un visiem atribūtiem tiek uzstatīts neieķeksētas kastītes attēls
                    let allCells = tagCollectionView.cellForItem(at: IndexPath(row: all, section: 0)) as! ReplaceStringsTagCell
                    allCells.checkbox.image = UIImage(named: "unchecked")
                }
            }
                // ja lietotājs veica pieskārienu kādai citai šūnai (nevis "SELECT ALL")
            else {
                // tad tiek iegūts atribūta indeks masīvā un šajā indeksā esošais elements tiek izņemts
                let index = array.index(of: cell.tagLabel.text!)
                array.remove(at: index!)
                cell.checkbox.image = UIImage(named: "unchecked")
            }
        }
        print(array)
    }

    // lietotājam izejot no šī skata
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let button = sender as? UIBarButtonItem, button === doneButton else {
            // ja lietotājs izgāja no skata nenospiežot pogu "done", tad izmaiņas netiek saglabātas
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return }

        // tiek iedarbināta funkcija tagChoice, kas veic izmaiņas visos Realm datubāzes Song objektos
        tagChoice()
    }
}
