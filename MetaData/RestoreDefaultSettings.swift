//
//  RestoreDefaultSettings.swift
//  MetaData
//
//  Created by Melanija Grunte on 01/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit

class RestoreDefaultSettings: UIViewController {

    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var restoreDefaultSettingsPopUp: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    confirmationLabel.numberOfLines = 0
    restoreDefaultSettingsPopUp.layer.cornerRadius = 10
    restoreDefaultSettingsPopUp.layer.masksToBounds = true
    }

    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func restoreSettings(_ sender: Any) {
        // formatStringRenamingSwitchOutlet.setOn(false, animated: true)
        dismiss(animated: true, completion: nil)
    }
}
