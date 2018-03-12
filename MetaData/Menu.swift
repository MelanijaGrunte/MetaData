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

//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = UIImage(named: "background.png")
//        backgroundImage.contentMode = UIViewContentMode.scaleToFill
//        self.view.insertSubview(backgroundImage, at: 0)
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
