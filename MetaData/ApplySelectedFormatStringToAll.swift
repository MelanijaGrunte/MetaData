//
//  ApplySelectedFormatStringToAll.swift
//  MetaData
//
//  Created by Melanija Grunte on 05/04/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import RealmSwift

class ApplySelectedFormatStringToAll: UIViewController {

    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var applySelectedFormatStringToAllPopUp: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationLabel.numberOfLines = 0
        applySelectedFormatStringToAllPopUp.layer.cornerRadius = 10
        applySelectedFormatStringToAllPopUp.layer.masksToBounds = true
    }

    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func applySelectedFormatStringToAll(_ sender: Any) {
        let realm = try! Realm()

        try! realm.write {
            for songs in realm.objects(Song.self) {
                SongNameFormatter().renamingFilenames(for: songs)
            }
        }

        dismiss(animated: true, completion: nil)
    }
}
