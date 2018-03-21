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

    let realm = try! Realm()
    var song: Song?
    var segueIdentifier = "segueToSongTableVC"
    var selectedIndex: Int! // labi
//    var tableSongs: Results<Song>!
    var tableSongs: Results<Song>!
//    var songs = [Song]()




    override func viewDidLoad() {
        super.viewDidLoad()

        noPhotoSelectedImage.image = UIImage(named: "defaultnophotoselected")

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
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

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
            if albumArtImage.image != nil && albumArtImage.image != UIImage(named: "defaultnophotoselected") {
                self.song!.albumArtImage = NSData(data: UIImagePNGRepresentation(albumArtImage.image!)!) as Data?  }       // probleema !!!
            self.song!.albumArtist = albumArtistText.text ?? nil } // probleema ka ja nekaa nav tad saglabaajas kaa tuksh un nestraadaa unknown artist

        if song?.albumArtImage != nil && segue.identifier == "bigImage"{
            if let pageDestination = segue.destination as? AlbumArt {
                pageDestination.image = albumArtImage.image }
            else {
                print("type destination not ok") }
        } else {
            print("segue inexistant") }

//            selectedIndex = selectedIndex + 1
//            print(selectedIndex)
//
//            let nextSong = songs[selectedIndex]
//            // let nextSongDetailViewController = segue.destination as? SongViewController
//                print("working")
//            print(nextSong)
//                //let indexPath = selectedIndex
//                //let selectedSong = tableSongs[indexPath!]
//            nextSongDetailViewController.song = nextSong
//                print("working here aswell")

        
        
        let segueChoice = SegueIdentifier()
        segueChoice.identifier = "segueToNextSongVC"
        try! realm.write {
            realm.add(segueChoice)
        }


        if let button = sender as? UIBarButtonItem, button === saveButton {

            var segueChoice: Results<SegueIdentifier>?
            segueChoice = realm.objects(SegueIdentifier.self)
            if let seg = segueChoice?.last {

                if seg.identifier == "unwindToSongTableView" {
                    let destination = segue.destination as! SongTableViewController
                    performSegue(withIdentifier: "unwindToSongTableView", sender: nil)
                    print("unwindToSongTableView")
                }

                if seg.identifier == "segueToNextSongVC" {

                    if ((selectedIndex + 1) < tableSongs.count) {
                        selectedIndex = selectedIndex + 1 // labi
                        let selectedSong = tableSongs[selectedIndex!] // labi

                        let destinationVC = SongViewController.storyboardInstance(storyboardId: "Main", restorationId: "SongViewController") as! SongViewController
                        destinationVC.song = selectedSong
                        self.navigationController?.pushViewController(destinationVC, animated: false)
                        // performSegue(withIdentifier: "segueToNextSongVC", sender: nil)
                        print("segueToNextSongVC")
                    }
                }
            }
        }
        else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return }
    }


    @IBAction func segueToNextSongVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SongViewController {
            //dataRecieved = sourceViewController.dataPassed
            print("im here")
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
            song!.albumArtImage = nil           // slikts risinaajums, jo ja spiezh cancel, tad tik un taa dziesmas bilde jau ir izdzeesta
        }
    }
}

func optionalStringToInt(string: String?) -> Int? {
    if let string = string {
        return Int(string)
    }
    return nil
}

extension UIViewController {
    class func storyboardInstance(storyboardId: String, restorationId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardId, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: restorationId)
    }
}
