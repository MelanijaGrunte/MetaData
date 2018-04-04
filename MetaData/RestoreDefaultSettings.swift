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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        confirmationLabel.numberOfLines = 0
        restoreDefaultSettingsPopUp.layer.cornerRadius = 10
        restoreDefaultSettingsPopUp.layer.masksToBounds = true
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restoreSettings(_ sender: Any) {
        //go to next song when finished editing switch
        let realm = try! Realm()
        let segueChoice = SegueIdentifier()
        segueChoice.identifier = "unwindToSongTVC"
        try! realm.write {
            realm.add(segueChoice)
        }

        // sort files by
        let attribute = Attribute()
        attribute.choice = "filename"
        try! realm.write {
            realm.add(attribute)
        }

        // choose column attribute


        // rename files automatically

        // select format string
        // tas būs uztaisīts par empty, lai, ja uzspiež, nekas nemainās. vai arī uztaisīts par filename

        dismiss(animated: true, completion: nil)
    }

    //    @IBAction func goToNextSongWhenFinishedEditingSwitch(_ sender: UISwitch) {
    //        let realm = try! Realm()
    //        let segueChoice = SegueIdentifier()
    //        segueChoice.identifier = "unwindToSongTVC"
    //        try! realm.write {
    //            realm.add(segueChoice)
    //        }
    //    }
}
