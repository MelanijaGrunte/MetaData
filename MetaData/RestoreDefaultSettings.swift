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

    @IBOutlet weak var popUpWidth: NSLayoutConstraint!
    @IBOutlet weak var popUpHeight: NSLayoutConstraint!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let segueIdentifier = realm.objects(SegueIdentifier.self)
        try! realm.write {
            segueIdentifier.setValue("unwindToSongTVC", forKeyPath: "identifier")
        }
        
        // sort files by
        let attribute = realm.objects(Attribute.self)
        try! realm.write {
            attribute.setValue("filename", forKeyPath: "choice")
        }
        
        // choose column attribute
        let column = realm.objects(Column.self)
        try! realm.write {
            column.setValue("filename", forKeyPath: "choice")
        }
        
        // rename files automatically
        let automaticFileRenaming = realm.objects(AutomaticFileRenaming.self)
        try! realm.write {
            automaticFileRenaming.setValue(false, forKeyPath: "automatically")
        }
        
        // custom format string
        let customFormatStringStyle = realm.objects(CustomFormatStringStyle.self)
        try! realm.write {
            customFormatStringStyle.setValue("", forKeyPath: "stringStyle")
            customFormatStringStyle.setValue(" ", forKeyPath: "separationText")
            customFormatStringStyle.setValue("unknown", forKeyPath: "tagReplacement")
        }

        // select custom format string
        let fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        try! realm.write {
            fileRenamingChoice.setValue("{filename}", forKeyPath: "chosenStyle")
            fileRenamingChoice.setValue(-1, forKeyPath: "chosenTag")
        }
        
        delegate.didRestoreSettings()
        dismiss(animated: true, completion: nil)
    }
}

protocol RestoreDefaultSettingsDelegate {
    func didRestoreSettings()
}
