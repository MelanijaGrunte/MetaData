//
//  RestoreDefaultSettings.swift
//  MetaData
//
//  Created by Melanija Grunte on 01/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import RealmSwift

class RestoreDefaultSettings: UIViewController {
    
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var restoreDefaultSettingsPopUp: UIView!
    @IBOutlet weak var popUpWidth: NSLayoutConstraint!
    @IBOutlet weak var popUpHeight: NSLayoutConstraint!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!

    // uzstāda iestatījumu slēdžiem neieslēgto statusu
    var switchStateForGoingToTheNextSong = false
    var switchStateForRenamingFilesAutomatically = false
    var delegate: RestoreDefaultSettingsDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // pielāgo skata augstumu, platumu, uzraksta un pogu teksta izmērus ierīcēm ar dažādiem augstumiem
        if UIScreen.main.bounds.size.height == 568 { // iPhone SE
            popUpWidth.constant = 180
            popUpHeight.constant = 105
            yesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            noButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            confirmationLabel.font = UIFont.systemFont(ofSize: 15.0)
        } else { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6 ; IPhone 8 Plus ; iPhone 7 Plus ; iPhone X
            popUpWidth.constant = 240
            popUpHeight.constant = 140
            yesButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
            noButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
            confirmationLabel.font = UIFont.systemFont(ofSize: 19.0)
        }

        // iespējo uzraksta dalīšanos vairākās rindās
        confirmationLabel.numberOfLines = 0
        // noapaļo skata stūrus
        restoreDefaultSettingsPopUp.layer.cornerRadius = 10
    }

    // lietotājam pieskaroties pogai "No", tiek aizvērts modāli parādītais skats
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // lietotājam pieskaroties pogai "Yes"
    @IBAction func restoreSettings(_ sender: Any) {
        let realm = try! Realm()

        // "go to next song when finished editing switch" iestatījumam piešķir noklusēto vērtību, kas uzstāda SongTableViewController kā nākamo skatu pēc faila rediģēšanas
        let segueIdentifier = realm.objects(SegueIdentifier.self)
        try! realm.write {
            segueIdentifier.setValue("unwindToSongTVC", forKeyPath: "identifier")
        }
        
        // "sort files by" iestatījumam uzstāda piešķir noklusēto vērtību, kas uzstāda faila nosaukumu kā atribūtu, pēc kura tiek kārtoti faili SongTableViewController skatā
        let attribute = realm.objects(Attribute.self)
        try! realm.write {
            attribute.setValue("filename", forKeyPath: "choice")
        }
        
        // "choose column attribute" iestatījumam piešķir noklusēto vērtību, kas uzstāda faila nosaukumu kā atribūtu, kurš tiek uzrādīts SongTableViewController skatā
        let column = realm.objects(Column.self)
        try! realm.write {
            column.setValue("filename", forKeyPath: "choice")
        }
        
        // "rename files automatically" iestatījumam piešķir noklusēto vērtību, kas norāda lietotnei automātiski nemainīt faila nosaukumu pēc lietotāja izvēlētā formāta
        let automaticFileRenaming = realm.objects(AutomaticFileRenaming.self)
        try! realm.write {
            automaticFileRenaming.setValue(false, forKeyPath: "automatically")
        }
        
        // "custom format string" iestatījumam piešķir noklusētās vērtības, kuras izdzēš lietotāja veidotu faila nosaukuma formātu
        let customFormatStringStyle = realm.objects(CustomFormatStringStyle.self)
        try! realm.write {
            customFormatStringStyle.setValue("", forKeyPath: "stringStyle")
            customFormatStringStyle.setValue(" ", forKeyPath: "separationText")
            customFormatStringStyle.setValue("{unknown %tag%}", forKeyPath: "tagReplacement")
        }

        // "select custom format string" iestatījumam piešķir noklusēto vērtību, kas izdzēš lietotāja aktīvā faila nosaukuma formāta izvēli
        let fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        try! realm.write {
            fileRenamingChoice.setValue("{filename}", forKeyPath: "chosenStyle")
            fileRenamingChoice.setValue(-1, forKeyPath: "chosenTag")
        }

        // informācijas padošanai, ka lietotājs ir atiestatījis noklusētās izmaiņas
        delegate.didRestoreSettings()
        // aizver modāli atvērto skatu
        dismiss(animated: true, completion: nil)
    }
}

// informācijas padošanai, ka lietotājs ir atiestatījis noklusētās izmaiņas
protocol RestoreDefaultSettingsDelegate {
    func didRestoreSettings()
}
