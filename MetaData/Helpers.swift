//
//  Helpers.swift
//  MetaData
//
//  Created by Melanija Grunte on 01/03/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import RealmSwift

// izveido objektu Attribute
class Attribute: Object {
    // ar mainīgo, kas glabā lietotāja izvēlēto atribūtu failu tabulas kārtošanai
    @objc dynamic var choice: String = "filename"
}

// izveido objektu Column
class Column: Object {
    // ar mainīgo, kas glabā lietotāja izvēlēto atribūtu failu tabulas uzraksta uzrādei
    @objc dynamic var choice: String = "filename"
}

// izveido objektu CustomFormatStringStyle
class CustomFormatStringStyle: Object {
    // ar mainīgajiem, kas glabā lietotāja izveidoto faila nosaukuma formātu, trūkstoša atribūta apstrādes veidu un atribūtu atšķiršanas simbolu virkni
    @objc dynamic var stringStyle: String = ""
    @objc dynamic var tagReplacement: String = "{unknown %tag%}"
    @objc dynamic var separationText: String = " "
}

// izveido objektu SegueIdentifier
class SegueIdentifier: Object {
    // ar mainīgo, kas glabā lietotāja izvēlēto skatu, kas atverās pēc rediģēta faila saglabāšanas
    @objc dynamic var identifier: String = "unwindToSongTVC"
}

// izveido objektu AutomaticFileRenaming
class AutomaticFileRenaming: Object {
    // ar mainīgo, kas glabā lietotāja izvēli - vai automātiski pārsaukt faila nosaukumus pēc to rediģēšanas, vai nē
    @objc dynamic var automatically: Bool = false
}

// izveido objektu FileRenamingChoice
class FileRenamingChoice: Object {
    // ar mainīgajiem, kas glabā lietotāja izvēlēto faila nosaukuma formātu un to kārtas skaitli
    @objc dynamic var chosenTag: Int = -1
    @objc dynamic var chosenStyle: String = "{filename}"
}
