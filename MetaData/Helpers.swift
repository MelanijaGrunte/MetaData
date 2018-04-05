//
//  Helpers.swift
//  MetaData
//
//  Created by Melanija Grunte on 01/03/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import RealmSwift

class Attribute: Object {
    @objc dynamic var choice: String = "filename"
}

class Column: Object {
    @objc dynamic var choice: String = "filename"
}

class CustomFormatStringStyle: Object {
    @objc dynamic var stringStyle: String = ""
}

class TagReplacement: Object {
    @objc dynamic var tagReplacement: String = ""
}

class Separation: Object {
    @objc dynamic var separationText: String = " "
}

class SegueIdentifier: Object {
    @objc dynamic var identifier: String = "unwindToSongTVC"
}

class AutomaticFileRenaming: Object {
    @objc dynamic var automatically: Bool = false
}

//class FileRenamingChoice: Object {
//    @objc dynamic var chosenStyle: Int = 1
//}
