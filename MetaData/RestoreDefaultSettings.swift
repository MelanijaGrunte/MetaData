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
    
    var switchStateForGoingToTheNextSong = false
    var switchStateForRenamingFilesAutomatically = false
    var delegate:RestoreDefaultSettingsDelegate!
    
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
        let realm = try! Realm()
        
        //go to next song when finished editing switch
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
        let column = Column()
        column.choice = "filename"
        try! realm.write {
            realm.add(column)
        }
        
        // rename files automatically
        let fileRenaming = AutomaticFileRenaming()
        fileRenaming.automatically = false
        try! realm.write {
            realm.add(fileRenaming)
        }
        
        // custom format string
        let customFormatString = CustomFormatStringStyle()
        customFormatString.stringStyle = ""
        try! realm.write {
            realm.add(customFormatString)
        }
        
        delegate.didRestoreSettings()
        dismiss(animated: true, completion: nil)
    }
}

protocol RestoreDefaultSettingsDelegate {
    func didRestoreSettings()
}
