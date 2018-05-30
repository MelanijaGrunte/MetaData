//
//  RealmHelper.swift
//  MetaData
//
//  Created by Melanija Grunte on 06/04/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    static func configureDefaultValues() {
        let realm = try! Realm()

        // ja kādā no Realm datubāzes objektiem nav vērtības, tiek uzstādītas noklusētās vērtības

        let attributeObjects = realm.objects(Attribute.self)
        if attributeObjects.isEmpty {
            let attribute = Attribute()
            attribute.choice = "filename"
            try! realm.write {
                realm.add(attribute)
            }
        } 
        let columnObjects = realm.objects(Column.self)
        if columnObjects.isEmpty {
            let column = Column()
            column.choice = "filename"
            try! realm.write {
                realm.add(column)
            }
        }
        let customFormatStringStyleObjects = realm.objects(CustomFormatStringStyle.self)
        if customFormatStringStyleObjects.isEmpty {
            let customFormatStringStyle = CustomFormatStringStyle()
            customFormatStringStyle.stringStyle = ""
            customFormatStringStyle.tagReplacement = "{unknown %tag%}"
            customFormatStringStyle.separationText = "-"
            try! realm.write {
                realm.add(customFormatStringStyle)
            }
        }
        let segueIdentifierObject = realm.objects(SegueIdentifier.self)
        if segueIdentifierObject.isEmpty {
            let segueIdentifier = SegueIdentifier()
            segueIdentifier.identifier = "unwindToSongTVC"
            try! realm.write {
                realm.add(segueIdentifier)
            }
        }
        let automaticFileRenamingObject = realm.objects(AutomaticFileRenaming.self)
        if automaticFileRenamingObject.isEmpty {
            let automaticFileRenaming = AutomaticFileRenaming()
            automaticFileRenaming.automatically = false
            try! realm.write {
                realm.add(automaticFileRenaming)
            }
        }
        let fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        if fileRenamingChoice.isEmpty {
            let fileRenamingChoice = FileRenamingChoice()
            fileRenamingChoice.chosenTag = -1
            fileRenamingChoice.chosenStyle = "{filename}"
            try! realm.write {
                realm.add(fileRenamingChoice)
            }
        }
    }
}
