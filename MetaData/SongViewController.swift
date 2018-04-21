//
//  SongViewController.swift
//  MetaData
//
//  Created by Melanija Grunte on 06/11/2017.
//  Copyright © 2017 Melanija Grunte. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class SongViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var filenameLabel: UILabel!
    @IBOutlet weak var filenameText: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var albumText: UITextField!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var trackText: UITextField!
    @IBOutlet weak var discnumberLabel: UILabel!
    @IBOutlet weak var discnumberText: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreText: UITextField!
    @IBOutlet weak var composerLabel: UILabel!
    @IBOutlet weak var composerText: UITextField!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var albumArtImage: UIImageView!
    @IBOutlet weak var noPhotoSelectedImage: UIImageView!
    @IBOutlet weak var albumArtistLabel: UILabel!
    @IBOutlet weak var albumArtistText: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var chooseAlbumArtButtonOutlet: UIButton!

    let realm = try! Realm()
    var song: Song?
    var segueFromController = "SongViewController"
    var segueIdentifier = "unwindToSongTVC"
    var selectedIndex: Int? // labi
    var tableSongs: Results<Song>!
    var timesPressedSave: Int?
    var removeAlbumArtImage: Bool?
    var delegate: SongVCDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let foregroundTopConstraint = self.contentView.constraints.filter{ $0.identifier == "betweenAttributes"}
        for element in 0..<foregroundTopConstraint.count {
            if UIScreen.main.bounds.size.height == 812 { // iPhone X
                foregroundTopConstraint[element].constant = foregroundTopConstraint[element].constant + 8
            } else if UIScreen.main.bounds.size.height == 736 { // IPhone 8 Plus ; iPhone 7 Plus
                foregroundTopConstraint[element].constant = foregroundTopConstraint[element].constant + 5
            } else if UIScreen.main.bounds.size.height == 667 { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6
                foregroundTopConstraint[element].constant = foregroundTopConstraint[element].constant
            } else if UIScreen.main.bounds.size.height == 568 { // iPhone SE
                foregroundTopConstraint[element].constant = foregroundTopConstraint[element].constant - 7
                chooseAlbumArtButtonOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            }
        }
//        let albumArtConstraint = self.albumArtImage.constraints.filter{ $0.identifier == "albumArt"}
//        let noAlbumArtConstraint = self.noPhotoSelectedImage.constraints.filter{ $0.identifier == "albumArt"}
//        for element in 0..<2 {
//            if UIScreen.main.bounds.size.height == 812 { // iPhone X
//                albumArtConstraint[element].constant = 120
//                noAlbumArtConstraint[element].constant = 120
//            } else if UIScreen.main.bounds.size.height == 736 { // IPhone 8 Plus ; iPhone 7 Plus
//                albumArtConstraint[element].constant = 100
//                noAlbumArtConstraint[element].constant = 100
//            } else if UIScreen.main.bounds.size.height == 667 { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6
//                albumArtConstraint[element].constant = 100
//                noAlbumArtConstraint[element].constant = 100
//            } else if UIScreen.main.bounds.size.height == 568 { // iPhone SE
//                albumArtConstraint[element].constant = 50
//                noAlbumArtConstraint[element].constant = 50
//            }
//        }


//        noPhotoSelectedImage.image = UIImage(named: "defaultnophotoselected")
        
        filenameText.delegate = self
        titleText.delegate = self
        artistText.delegate = self
        albumText.delegate = self
        trackText.delegate = self
        discnumberText.delegate = self
        yearText.delegate = self
        genreText.delegate = self
        composerText.delegate = self
        commentText.delegate = self
        albumArtistText.delegate = self
        
        if let song = song {
            filenameText.text = song.filename
            titleText.text = song.title ?? nil
            artistText.text = song.artist ?? nil
            albumText.text = song.album ?? nil
            if let track = song.track.value {
                trackText.text = String(describing: track)
            }
            if let discnumber = song.discnumber.value {
                discnumberText.text = String(describing: discnumber)
            }
            if let year = song.year.value {
                yearText.text = String(describing: year)
            }
            genreText.text = song.genre ?? nil
            composerText.text = song.composer ?? nil
            commentText.text = song.comment ?? nil
            if let image = song.albumArtImage {
                albumArtImage.image = UIImage(data: image) ?? nil}
            albumArtistText.text = song.albumArtist ?? nil
        }
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let realm = try! Realm()
        try! realm.write() {
            albumArtImage.image = selectedImage }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func saveIsTapped(_ sender: UIBarButtonItem) {
        
        let realm = try! Realm()
        try! realm.write {
            self.song!.filename = filenameText.text ?? ""
            self.song!.title = titleText.text ?? nil
            self.song!.artist = artistText.text ?? nil
            self.song!.album = albumText.text ?? nil
            self.song!.track.value = optionalStringToInt(string: trackText.text) ?? nil
            self.song!.discnumber.value = optionalStringToInt(string: discnumberText.text) ?? nil
            self.song!.year.value = optionalStringToInt(string: yearText.text) ?? nil
            self.song!.genre = genreText.text ?? nil
            self.song!.composer = composerText.text ?? nil
            self.song!.comment = commentText.text ?? nil
            if albumArtImage.image != nil && albumArtImage.image != UIImage(named: "defaultnophotoselected") && removeAlbumArtImage != true {
                self.song!.albumArtImage = NSData(data: UIImagePNGRepresentation(albumArtImage.image!)!) as Data? 
            } else {
                self.song!.albumArtImage = nil }
            self.song!.albumArtist = albumArtistText.text ?? nil }
        
        var isAutomatic: Results<AutomaticFileRenaming>?
        isAutomatic = realm.objects(AutomaticFileRenaming.self)
        if let aut = isAutomatic?.last {
            if aut.automatically == true {
                try! realm.write {
                        SongNameFormatter().renamingFilenames(for: self.song!)
                }
            }
        }
        
        let segueChoice = realm.objects(SegueIdentifier.self)
        if let seg = segueChoice.last {
            
            if seg.identifier == "unwindToSongTVC" {
                self.navigationController?.popViewController(animated: true)
                delegate?.didFinishSongVC(controller: self)
            }
            if seg.identifier == "segueToNextSongVC" {

                if ((selectedIndex! + 1) < tableSongs.count) {

                    if let navController = self.navigationController {
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let nextSongVC : SongViewController = storyboard.instantiateViewController(withIdentifier: "SongViewController") as! SongViewController

                        selectedIndex = selectedIndex! + 1
                        let selectedSong = tableSongs[selectedIndex!]
                        nextSongVC.song = selectedSong
                        nextSongVC.selectedIndex = selectedIndex
                        nextSongVC.tableSongs = tableSongs
                        if timesPressedSave == nil {
                            nextSongVC.timesPressedSave = 1
                        } else {
                            nextSongVC.timesPressedSave = timesPressedSave! + 1
                        }
                        var stack = navController.viewControllers
                        stack.remove(at: stack.count - 1)
                        stack.insert(nextSongVC, at: stack.count)
                        navController.setViewControllers(stack, animated: false)
                    }
                } else {
                    self.navigationController?.popViewController(animated: true)
                    delegate?.didFinishSongVC(controller: self)
                }
            }
        }
    }
    
    @IBAction func cancelIsTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        delegate?.didFinishSongVC(controller: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if song?.albumArtImage != nil && segue.identifier == "bigImage"{
            if let pageDestination = segue.destination as? AlbumArt {
                pageDestination.image = albumArtImage.image }
            else {
                print("type destination not ok") }
        } else {
            print("no album art clicked")
            return
        }
    }
    
    //MARK: Actions
    
    @IBAction func ChooseAlbumArtButton(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func removeAlbumArtButton(_ sender: UIButton) {
        let realm = try! Realm()
        try! realm.write() {
            albumArtImage.image = nil
            removeAlbumArtImage = true
        }
    }
}

func optionalStringToInt(string: String?) -> Int? {
    if let string = string {
        return Int(string)
    }
    return nil
}

protocol SongVCDelegate {
    func didFinishSongVC(controller: SongViewController)
}
