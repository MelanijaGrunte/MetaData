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
    var tagReplacement: String = "{unknown %tag%}"

    // piešķir vērtības atribūtiem to ērtai lasīšanai
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

    // piešķir atribūtu apraksta vērtības atribūtu tipiem to pievienošanai masīvā chosenTags, kas pēc tam būs ērti apstrādājams SongNameFormatter
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

    // izveido atribūtu tipu vērtības
    let tags: [CheckBoxes] = [.title, .artist, .album, .track, .discnumber, .year, .genre, .composer, .comment, .albumArtist]

    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        // veic izmaiņas kolekcijā un saņem kolekcijas datus
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self

        // atribūtu atšķiršanas simbola lauciņš uztver satura izmaiņas
        separation.delegate = self

        // attēlo "unknown %tag%" pogu, kā jau izvēlēto veidu trūkstošo atribūtu apstrādei
        unknownTagReplacement.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

        // lietotāja pašuzrakstītā trūkstošā atribūta simbolu virknes teksta lauciņš uztver satura izmaiņas, lietotājam spiežot "return" beidzas teksta rediģēšana
        customReplacement.delegate = self
        customReplacement.returnKeyType = UIReturnKeyType.done
        // izsauc funkciju tekstFieldDidChange, kad ir veiktas izmaiņas
        customReplacement.addTarget(self, action: #selector(CustomFormatString.textFieldDidChange(_:)),
                                    for: UIControlEvents.editingChanged)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            // piešķir atribūtu izvēlnes skata šūnām platumu (kas tiek dalīts 3 vienādās ekrāna daļās) un augstumu (atkarībā no ierīces ekrāna augstuma)
            let itemWidth = tagCollectionView.bounds.width / 3.0
            var itemHeight = layout.itemSize.height
            if UIScreen.main.bounds.size.height == 568 {
                itemHeight = 34
            }
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }

    // uzspiežot uz pogas ar virsrakstu "unknown %tag%", tā tiek izcelta ar treknrakstu, "custom:" teksta ierakstīšanas lauciņš tiek iztīrīts un Realm datubāzē objektam CustomFormatStringStyle "tagReplacement" keyPatham tiek dota vērtība "{unknown %tag%}"
    @IBAction func unknownTagReplacement(_ sender: UIButton) {
        unknownTagReplacement.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nothingReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        noReplacementSelection.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.systemFont(ofSize: 15)
        customReplacement.text = nil

        tagReplacement = "{unknown %tag%}"
    }

    // uzspiežot uz pogas ar virsrakstu "nothing", tā tiek izcelta, "custom:" teksta ierakstīšanas lauciņš tiek iztīrīts un Realm datubāzē objektam CustomFormatStringStyle "tagReplacement" keyPatham tiek dota vērtība "{empty}"
    @IBAction func nothingReplacement(_ sender: UIButton) {
        nothingReplacement.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        unknownTagReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        noReplacementSelection.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.systemFont(ofSize: 15)
        customReplacement.text = nil

        tagReplacement = "{empty}"
    }

    // uzspiežot uz pogas ar virsrakstu "don't change the files name", tā tiek izcelta, "custom:" teksta ierakstīšanas lauciņš tiek iztīrīts un Realm datubāzē objektam CustomFormatStringStyle "tagReplacement" keyPatham tiek dota vērtība "{unchanged filename}".
    @IBAction func noReplacementSelection(_ sender: UIButton) {
        noReplacementSelection.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nothingReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        unknownTagReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.systemFont(ofSize: 15)
        customReplacement.text = nil

        tagReplacement = "{unchanged filename}"
    }

    // uzspiežot uz teksta ierakstīšanas lauciņa blakus uzrakstam "custom:", uzraksts tiek izcelts, ierakstītais teksts tiek piefiksēts un saglabāts Realm datubāzē objektam CustomFormatStringStyle "tagReplacement" keyPathā.
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        self.customReplacement.text = customReplacement.text ?? nil
        nothingReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        unknownTagReplacement.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        noReplacementSelection.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        customLabel.font = UIFont.boldSystemFont(ofSize: 15)

        tagReplacement = customReplacement.text!
    }

    // kolekcijas skatam tiek pievienotas tik vienības, cik ir atribūtu
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    // kā kolekcijas skata šūnas tiek iestatītas CustomFormatStringTagCell šūnas, to uzrakstiem tiek iestatīti atribūtu nosaukumi un tām piešķir atribūtu tipu vērtības
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomFormatStringTagCell
        cell.tagLabel.text = tags[indexPath.row].rawValue
        let type = tags[indexPath.row]
        cell.cellValue = tagChoice(for: type)

        // šūnu teksta izmērs tiek pielāgots dažāda platuma ierīču ekrāniem
        if UIScreen.main.bounds.size.width == 375 { // iPhone X ; iPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6
            if UIScreen.main.bounds.size.height == 812 {
                cell.tagLabel.font = UIFont.systemFont(ofSize: 15.0)
            } else {
                cell.tagLabel.font = UIFont.systemFont(ofSize: 14.0) }
        } else if UIScreen.main.bounds.size.width == 414 { // IPhone 8 Plus ; iPhone 7 Plus
            cell.tagLabel.font = UIFont.systemFont(ofSize: 15.0)
        } else if UIScreen.main.bounds.size.width == 320 { // iPhone SE
            cell.tagLabel.font = UIFont.systemFont(ofSize: 13.0)
        }

        return cell
    }

    // atribūtu pievienošana/noņemšana lietotājam veicot pieskārienu kādai no šūnām
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath) as! CustomFormatStringTagCell

        // ja lietotājs vēl nav izvēlējies atribūta šūnu, kurai tikko veica pieskārienu (ja masīvā šis atribūts neitilpst)
        if chosenTags.contains(cell.cellValue) == false {
            // tad atribūtu pievieno masīvam
            chosenTags.append(cell.cellValue)
        } else {
            // citādāk šūnas pogai uzliek tukšas kastītes attēlu un atribūtu izņem no masīva
            let index = chosenTags.index(of: cell.cellValue)
            chosenTags.remove(at: index!)
            cell.checkbox.image = UIImage(named: "empty")
        }

        // šūnu pogām piešķir attēlu ar masīva kārtas skaitli kastītē
        for row in 0..<10 {
            for element in 0..<chosenTags.count {
                let allCells = tagCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as! CustomFormatStringTagCell
                if chosenTags[element] == allCells.cellValue {
                    allCells.checkbox.image = UIImage(named: "\(element+1)")
                }
            }
        }
    }

    // formāta izveidošanas funkcija, kura tiek izsaukta saglabājot izmaiņas
    func createFormatString() {
        let customFormatStringStyle = realm.objects(CustomFormatStringStyle.self)
        // ja lietotājs ir izvēlējies vismaz vienu atribūtu
        if chosenTags.count > 0 {
            // pirmo izvēlēto atbibūtu pievieno formāta mainīgajam
            var result = "\(chosenTags[0])"
            for element in 1..<chosenTags.count {
                // katru nākamo izvēlēto atribūtu pievieno formātam klāt pirms tā pieliekot lietotāja uzrakstīto atribūtu atšķiršanas simbolu virkni
                let repeatingString = " \(separation.text!) \(chosenTags[element])"
                result = result + repeatingString
            }
            try! realm.write {
                // saglabā izveidoto formātu Realm datubāzē
                customFormatStringStyle.setValue(result, forKeyPath: "stringStyle")
                customFormatStringStyle.setValue(tagReplacement, forKey: "tagReplacement")
            }
            // saglabā lietotāja uzrakstīto atribūtu atšķiršanas virkni Realm datubāzē. Ja lietotājs nav veicis ierakstu, tam tiek uzstādīta vienas atstarpes vērtība
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

        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return }

        // nolasot visas lietotāja ievadītās/izvēlētās vērtības, izveido faila nosaukuma formātu, kuru saglabā datubāzē
        createFormatString ()

        var fileRenamingChoice: Results<FileRenamingChoice>
        fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        let format = fileRenamingChoice.last

        var customFormatStringStyle: Results<CustomFormatStringStyle>
        customFormatStringStyle = realm.objects(CustomFormatStringStyle.self)
        let style = customFormatStringStyle.last

        // ja lietotājs pirms tam bija izvēlējies sevis izveidoto formātu, kā aktīvo faila nosaukuma formātu, tad tā vērtība tiek saglabāta Realm datubāzē aktīvajam faila nosaukuma formātam
        if format?.chosenTag == 8 {
            try! realm.write {
                fileRenamingChoice.setValue(style?.stringStyle, forKey: "chosenStyle")
            }
        }
    }
}
