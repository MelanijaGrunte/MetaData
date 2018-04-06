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
        let segueIdentifier = SegueIdentifier()
        try! realm.write {
            segueIdentifier.identifier = "unwindToSongTVC"
        }
        
        // sort files by
        let attribute = Attribute()
        try! realm.write {
            attribute.choice = "filename"
        }
        
        // choose column attribute
        let column = Column()
        try! realm.write {
            column.choice = "filename"
        }
        
        // rename files automatically
        let automaticFileRenaming = AutomaticFileRenaming()
        try! realm.write {
            automaticFileRenaming.automatically = false
        }
        
        // custom format string
        let customFormatStringStyle = CustomFormatStringStyle()
        try! realm.write {
            customFormatStringStyle.stringStyle = ""
            customFormatStringStyle.separationText = " "
            customFormatStringStyle.tagReplacement = "unknown"
        }

        // select custom format string
        let fileRenamingChoice = FileRenamingChoice()
        try! realm.write {
            fileRenamingChoice.chosenStyle = "{filename}"
            fileRenamingChoice.chosenTag = -1
        }

        delegate.didRestoreSettings()
        dismiss(animated: true, completion: nil)
    }
}

protocol RestoreDefaultSettingsDelegate {
    func didRestoreSettings()
}
