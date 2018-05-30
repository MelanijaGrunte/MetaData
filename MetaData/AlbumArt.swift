//
//  AlbumArt.swift
//  MetaData
//
//  Created by Melanija Grunte on 12/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import RealmSwift

class AlbumArt: UIViewController {

    // atsūtītais attēls no SongViewController
    var image: UIImage? = nil

    @IBOutlet weak var bigAlbumArt: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // pārliecinās, vai image vērtība nav tukša. ja nav
        if image != nil {
            // piešķir attēla objektam atsūtīto attēlu no SongViewController
            bigAlbumArt.image = image
            // piešķir modāli atvērtajam skatam tīru fonu, izveido miglainu efektu, izveido miglaina efekta skatu stiepjamies no malas līdz malai un uzliek to zem attēla objekta
            view.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            blurEffectView.superview?.bringSubview(toFront: bigAlbumArt)
        } else {
            print("image not found")
        }
        
    }

    // lietotājam veicot pieskārienu, tiek izslēgts atvērtais skats
    @IBAction func pressToDismiss(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
