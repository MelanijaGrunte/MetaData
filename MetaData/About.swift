//
//  FAQ.swift
//  MetaData
//
//  Created by Melanija Grunte on 23/11/2017.
//  Copyright © 2017 Melanija Grunte. All rights reserved.
//

import UIKit

class About: UIViewController, UITextViewDelegate {

    @IBOutlet weak var aboutText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

    aboutText.text = "Metadatiņi is a tool to edit metadata of audio files.\n\nSupported audio formats:\n-Apple Losless Audio Format (alac)\n-Free Losless Audio Format (flac)\n-Mpeg Layer 3 (mp3)\n-MPEG-4 (mp4, m4a, m4b, m4v, iTunes)\n-True Audio (tta)\n-WAV (wav)"

    aboutText.font = UIFont(name: "Verdana", size: 20)
    aboutText.isEditable = false
    aboutText.textAlignment = .left
    }
}
