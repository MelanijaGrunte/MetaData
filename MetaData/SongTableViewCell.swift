//
//  SongTableViewCell.swift
//  MetaData
//
//  Created by Melanija Grunte on 12/11/2017.
//  Copyright © 2017 Melanija Grunte. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var albumArtImage: UIImageView!
    @IBOutlet weak var columnAttribute: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        if albumArtImage.image == nil {
        //            albumArtImage.image = UIImage(named: "defaultnoalbumart")
        //        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
