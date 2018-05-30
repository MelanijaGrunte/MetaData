//
//  Menu.swift
//  MetaData
//
//  Created by Melanija Grunte on 09/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit

class Menu: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // skatam ielādējoties netiks attēlota navigācijas josla
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // izejot no skata navigācijas joslas slēpšana tiks atspējota
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
