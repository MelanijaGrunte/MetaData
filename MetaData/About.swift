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

//    aboutText.text = nil

        func attributedText() -> NSAttributedString {

            let string = "Metadatiņi is a tool to edit metadata of audio files.\n\nMain features:\nBatch Tag Editing Write ID3v1.1, ID3v2.3, ID3v2.4, MP4, WMA, APEv2 Tags and Vorbis Comments to multiple files at once.\nSupport for Cover Art Download and add album covers to your files and make your library even more shiny.\nReplace characters or words Replace strings in tags and filenames (with support for Regular Expressions).\nRename files from tags Rename files based on the tag information and import tags from filenames.\nFull Unicode Support User-interface and tagging are fully Unicode compliant.\n\nBesides these main features Mp3tag offers a variety of other functions and features ranging ranging from batch export of embedded album covers, over support for iTunes-specific tags like media type or TV Show settings, to combining multiple actions into groups that can be applied with a single mouse click.\n\nSupported audio formats:\n-Apple Losless Audio Format (alac)\n-Free Losless Audio Format (flac)\n-Mpeg Layer 3 (mp3)\n-MPEG-4 (mp4, m4a, m4b, m4v, iTunes)\n-True Audio (tta)\n-WAV (wav)" as NSString

            let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0)])
            let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16.0)] // !!!
            let biggerFontAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0)] // !!!

            // Part of string to be bold
            attributedString.addAttributes(biggerFontAttribute, range: string.range(of: "Metadatiņi is a tool to edit metadata of audio files."))
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Metadatiņi"))
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Main features:"))
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Batch Tag Editing"))
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Support for Cover Art"))
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Replace characters or words"))
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Rename files from tags"))
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Full Unicode Support"))
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Supported audio formats:"))

            // 4
            return attributedString
        }

        aboutText.attributedText = attributedText()

    aboutText.isEditable = false
    aboutText.textAlignment = .left
    }
}
