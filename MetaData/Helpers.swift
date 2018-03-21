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
    @objc dynamic var stringStyle: String = "\\(song.filename)"
}

class SegueIdentifier: Object {
    @objc dynamic var identifier: String = "nextSongVC"
}

//
//class CustomFormatStringStyleArray: Object {
//    @objc dynamic var values: Array = [String]()
//}

