//
//  ReplaceStringsTagCell.swift
//  MetaData
//
//  Created by Melanija Grunte on 05/03/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit

class ReplaceStringsTagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var checkbox: UIImageView!
    
    // piešķir attēla objektam neieķeksētas kastītes attēlu
    override func awakeFromNib() {
        checkbox.image = UIImage(named: "unchecked")
    }
}
