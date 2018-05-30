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
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewWidth: NSLayoutConstraint!

    // piešķir vērtības kārtošanas atribūtu tipiem to ērtai lasīšanai
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

    // piešķir atribūtu vērtības kārtošanas atribūtu tipiem vēlākai nolasīšanai klasē SongTableViewController
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

    // izveido kārtošanas atribūtu tipu vērtības
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
        // ielādē tabulas datus, piefiksē to izmaiņas, noapaļo stūrus
        sortFilesByTableView.dataSource = self
        sortFilesByTableView.delegate = self
        sortFilesByTableView.layer.cornerRadius = 10
    }

    // izveido tabulā tik rindas, cik ir kārtošanas atribūtu tipu
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count;
    }
    
    // MARK: actions

    // pielāgo rindu augstumu atkarībā no ierīces ekrāna augstuma
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIScreen.main.bounds.size.height == 568 { // iPhone SE
            return 35
        } else { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6 ; IPhone 8 Plus ; iPhone 7 Plus ; iPhone X
            return 40
        }
    }

    // funkcija, kas izpildās lietotājam pieskaroties kādai no rindām
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        // izveido mainīgo ar izvēlētās rindas vērtību
        let type = attributes[indexPath.row]
        let realm = try! Realm()
        let attribute = realm.objects(Attribute.self)
        try! realm.write {
            // saglabā Realm datubāzē izvēlēto atribūtu
            attribute.setValue(attributeChoice(for: type), forKeyPath: "choice")
        }
        tableView.reloadData()
        // izslēdz modāli atvērto skatu
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // pielāgo tabulas skata augstumu un platumu atkarībā no ierīces ekrāna augstuma
        if UIScreen.main.bounds.size.height == 568 { // iPhone SE
            tableViewHeight.constant = 385
            tableViewWidth.constant = 200
        } else { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6 ; IPhone 8 Plus ; iPhone 7 Plus ; iPhone X
            tableViewHeight.constant = 440
            tableViewWidth.constant = 250
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell

        // lai līnijas starp rindām būtu no malas līdz malai
        cell.textLabel?.textAlignment = .center
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        // seperator ir pilna garuma

        // pievieno šūnu uzrakstiem atribūtu nosaukumus
        cell.textLabel?.text = attributes[indexPath.row].rawValue
        // pielāgo šūnu teksta izmēru atkarībā no ierīces ekrāna augstuma
        if UIScreen.main.bounds.size.height == 568 { // iPhone SE
            cell.textLabel?.font = cell.textLabel?.font.withSize(15)
        } else {
            cell.textLabel?.font = cell.textLabel?.font.withSize(18)
        }
        return cell
    }
}
