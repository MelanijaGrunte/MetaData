//
//  CustomFormatStringTagCell.swift
//  MetaData
//
//  Created by Melanija Grunte on 05/03/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit

class CustomFormatStringTagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var checkbox: UIImageView!
    
    var cellValue: String = ""

    // piešķir attēla objektam tukšas kastītes attēlu
    override func awakeFromNib() {
        checkbox.image = UIImage(named: "empty")
    }
}
