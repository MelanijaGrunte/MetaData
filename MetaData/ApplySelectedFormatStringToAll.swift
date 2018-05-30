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
    @IBOutlet weak var popUpHeight: NSLayoutConstraint!
    @IBOutlet weak var popUpWidth: NSLayoutConstraint!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // pielāgo skata augstumu, platumu, uzraksta un pogu teksta izmērus ierīcēm ar dažādiem augstumiem
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

        // iespējo uzraksta dalīšanos vairākās rindās
        confirmationLabel.numberOfLines = 0
        // noapaļo skata stūrus
        applySelectedFormatStringToAllPopUp.layer.cornerRadius = 10
    }

    // lietotājam pieskaroties pogai "No", tiek aizvērts modāli parādītais skats
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // lietotājam pieskaroties pogai "Yes"
    @IBAction func applySelectedFormatStringToAll(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            for songs in realm.objects(Song.self) {
                // visus datubāzes Song objektus apstrādā klasē SongNameFormatter
                SongNameFormatter().renamingFilenames(for: songs)
            }
        }
        // aizver modāli atvērto skatu
        dismiss(animated: true, completion: nil)
    }
}
