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
    @IBOutlet weak var tableViewWidth: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // piešķir formātu tipiem vērtības to ērtai lasīšanai
    enum filenameType: String {
        case artistAlbumTrackTitle = "artist - album - track - title"
        case artistAlbumTitle = "artist - album - title"
        case artistTitle = "artist - title"
        case albumTrackTitle = "album - track - title"
        case albumTitle = "album - title"
        case trackTitle = "track - title"
        case title = "title"
        case artistTrackAlbum = "artist - track - album"
        case defaultString = "your custom format style"
    }

    // piešķir formātu tipiem vērtības vēlākai apstrādāšanai klasē SongNameFormatter
    func filenameString(for type: filenameType) -> String {
        switch type {
        case .artistAlbumTrackTitle:
            return "{artistDescription} - {albumDescription} - {trackDescription} - {titleDescription}"
        case .artistAlbumTitle:
            return "{artistDescription} - {albumDescription} - {titleDescription}"
        case .artistTitle:
            return "{artistDescription} - {titleDescription}"
        case .albumTrackTitle:
            return "{albumDescription} - {trackDescription} - {titleDescription}"
        case .albumTitle:
            return "{albumDescription} - {titleDescription}"
        case .trackTitle:
            return "{trackDescription} - {titleDescription}"
        case .title:
            return "{titleDescription}"
        case .artistTrackAlbum:
            return "{artistDescription} - {trackDescription} - {albumDescription}"
        case .defaultString:
            let realm = try! Realm()
            var customFormatString: Results<CustomFormatStringStyle>?
            customFormatString = realm.objects(CustomFormatStringStyle.self)
            let style = customFormatString?.last
            return style!.stringStyle
        }
    }

    // izveido formātu tipu vērtības
    let types: [filenameType] = [
        .artistAlbumTrackTitle,
        .artistAlbumTitle,
        .artistTitle,
        .albumTrackTitle,
        .albumTitle,
        .trackTitle,
        .title,
        .artistTrackAlbum,
        .defaultString
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // ielādē tabulas datus, piefiksē to izmaiņas, noapaļo stūrus
        selectFormatStringTableView.dataSource = self
        selectFormatStringTableView.delegate = self
        selectFormatStringTableView.layer.cornerRadius = 10
    }

    //  pielāgo rindu augstumu dažāda augstuma ekrāniem
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIScreen.main.bounds.size.height == 568 { // iPhone SE
            return 35
        } else { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6 ; IPhone 8 Plus ; iPhone 7 Plus ; iPhone X
            return 40
        }
    }

    // uzstāda tik rindas, cik ir formāta tipu
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count;
    }

    // uzstāda tabulai, to šūnām izskatu
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        // centrē šūnu uzrakstus
        cell.textLabel?.textAlignment = .center
        // piešķir šūnu uzrakstiem tipu vērtības
        cell.textLabel?.text = types[indexPath.row].rawValue

        //  pielāgo uznirstošā skata augstumu, platumu un teksta izmēru dažāda augstuma ekrāniem
        if UIScreen.main.bounds.size.height == 568 { // iPhone SE
            tableViewHeight.constant = 315
            tableViewWidth.constant = 250
            cell.textLabel?.font = cell.textLabel?.font.withSize(15)
        } else { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6 ; IPhone 8 Plus ; iPhone 7 Plus ; iPhone X
            tableViewHeight.constant = 360
            tableViewWidth.constant = 300
            cell.textLabel?.font = cell.textLabel?.font.withSize(18)
        }

        let realm = try! Realm()

        var fileRenamingChoice: Results<FileRenamingChoice>?
        fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        let format = fileRenamingChoice?.last
        // ja lietotājs ir jau bijis izvēlējies kādu no šūnām, tad šī izvēle tiek attēlota pievienojot šūnai ķeksīti
        if indexPath == IndexPath(row: (format?.chosenTag)!, section: 0) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }

        var customFormatString: Results<CustomFormatStringStyle>?
        customFormatString = realm.objects(CustomFormatStringStyle.self)
        let style = customFormatString?.last
        // ja lietotājs nav izveidojis savu formātu (vai ir saglabājis formātu bez atribūtiem), tad "your custom format style" šūna nevar tikt izvēlēta un ir attiecīgi attēlota
        if style!.stringStyle == "" && indexPath.row == 8 {
            cell.isUserInteractionEnabled = false
            cell.textLabel?.textColor = UIColor(white: 0.75, alpha:1)
        }
        return cell
    }
    
    // MARK: actions

    // funkcija, kura tiek izsaukta veicot pieskārienu kādai no šūnām
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // iegūst izvēlētās šūnas tipu
        let type = types[indexPath.row]

        // saglabā lietotāja izvēlēto formātu un tā kārtas numuru datubāzē
        let realm = try! Realm()
        let fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        try! realm.write {
            fileRenamingChoice.setValue(filenameString(for: type), forKeyPath: "chosenStyle")
            fileRenamingChoice.setValue(indexPath.row, forKeyPath: "chosenTag")
        }

        // noņem iepriekš izvēlētās šūnas ķeksīti
        for row in 0...8 {
            tableView.cellForRow(at: IndexPath(row: row, section: 0))?.accessoryType = UITableViewCellAccessoryType.none
        }
        // piešķir jaunizvēlētajai šūnai ķeksīti
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark

        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

