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
    @IBOutlet weak var albumArtistLabel: UILabel!
    @IBOutlet weak var albumArtistText: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var chooseAlbumArtButtonOutlet: UIButton!

    let realm = try! Realm()
    var song: Song?
    var segueFromController = "SongViewController"
    var segueIdentifier = "unwindToSongTVC"
    var selectedIndex: Int?
    var tableSongs: Results<Song>!
    var removeAlbumArtImage: Bool?
    var delegate: SongVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let foregroundTopConstraint = self.contentView.constraints.filter{ $0.identifier == "betweenAttributes"}
        // atribūtu uzrakstu un ievades lauciņu starpu pielāgošana dažāda izmēra (augstuma) ekrāniem
        for element in 0..<foregroundTopConstraint.count {
            if UIScreen.main.bounds.size.height == 812 { // iPhone X
                foregroundTopConstraint[element].constant = foregroundTopConstraint[element].constant + 8
            } else if UIScreen.main.bounds.size.height == 736 { // IPhone 8 Plus ; iPhone 7 Plus
                foregroundTopConstraint[element].constant = foregroundTopConstraint[element].constant + 5
            } else if UIScreen.main.bounds.size.height == 667 { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6
                foregroundTopConstraint[element].constant = foregroundTopConstraint[element].constant
            } else if UIScreen.main.bounds.size.height == 568 { // iPhone SE
                foregroundTopConstraint[element].constant = foregroundTopConstraint[element].constant - 7
                // samazina teksta izmēru albuma vāciņa pievienošanas pogai, lai tas neizietu no rāmjiem
                chooseAlbumArtButtonOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            }
        }

        // teksta lauciņa satura maiņas uztveršanai
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

        // pievieno atvērtā faila metadatus attiecīgajos teksta lauciņos
        if let song = song {
            filenameText.text = song.filename
            titleText.text = song.title ?? nil
            artistText.text = song.artist ?? nil
            albumText.text = song.album ?? nil
            // skaitliskajiem mainīgajiem vērtību pārkonvertē uz String, lai to varētu piešķirt teksta lauciņiem
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
            // albuma vāciņa Data tipa mainīgajiem vērtību pārkonvertē uz UIImage, lai to varētu piešķirt attēla objektam
            // ja albuma vāciņa atvērtajam failam nav, tad attēla objektam piešķir neesoša albuma vāciņa attēlu
            if let image = song.albumArtImage {
                albumArtImage.image = UIImage(data: image) ?? UIImage(named: "defaultnophotoselected")}
            albumArtistText.text = song.albumArtist ?? nil
        }
    }
    
    //MARK: UITextFieldDelegate

    // lietotājam teksta lauciņa rediģēšanas laikā uzspiežot return pogu, aizverās tastatūra
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // ziņo, ka teksta lauciņa vērtības maiņa ir beigusies, lai delegātam padotu tā vērtību
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    //MARK: UIImagePickerControllerDelegate

    // funkcija, kas tiek izsaukta atceļot attēla izvēli UIIMagePickerController skatā
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // noņem modāli atvērto skatu
        dismiss(animated: true, completion: nil)
    }

    // funkcija, kas izpildās lietotājam izvēloties attēlu UIImagePickerController skatā
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // ja lietotāja izvēle nav attēls, tad parādās attiecīgs kļūdas paziņojums
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // pievieno attēla objektam izvēlēto attēlu
        albumArtImage.image = selectedImage
        // norāda, ka lietotāja pēdējā izvēle nav bijusi albuma vāciņa dzēšana
        removeAlbumArtImage = false
        // aizver modāli atvērto UIImagePickerController skatu
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation

    // funckija, kas izpildās lietotājam veicot pieskārienu navigācijas pogai "save"
    @IBAction func saveIsTapped(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        // failam piešķir visas teksta lauciņa vērtības
        try! realm.write {
            self.song!.filename = filenameText.text ?? ""
            self.song!.title = titleText.text ?? nil
            self.song!.artist = artistText.text ?? nil
            self.song!.album = albumText.text ?? nil
            // skaitliskajiem metadatiem teksta lauciņa simbolu virkni pārkonvertē uz Int tipu, lai tiem būtu piemērota vērtība
            self.song!.track.value = optionalStringToInt(string: trackText.text) ?? nil
            self.song!.discnumber.value = optionalStringToInt(string: discnumberText.text) ?? nil
            self.song!.year.value = optionalStringToInt(string: yearText.text) ?? nil
            self.song!.genre = genreText.text ?? nil
            self.song!.composer = composerText.text ?? nil
            self.song!.comment = commentText.text ?? nil
            // ja attēla objektam ir vērtība, bet tas nav neesoša albuma vāciņa attēls un lietotājs nav rediģēšanas laikā vēlējies izdzēst albuma vāciņu, tad attēlu pievieno faila metadatam
            if albumArtImage.image != nil && albumArtImage.image != UIImage(named: "defaultnophotoselected") && removeAlbumArtImage != true {
                self.song!.albumArtImage = NSData(data: UIImagePNGRepresentation(albumArtImage.image!)!) as Data? 
            } else {
                // citādāk failam tiek noņemts albuma vāciņa attēls
                self.song!.albumArtImage = nil }
            self.song!.albumArtist = albumArtistText.text ?? nil }
        
        var isAutomatic: Results<AutomaticFileRenaming>?
        isAutomatic = realm.objects(AutomaticFileRenaming.self)
        // ja lietotājs ir izvēlējies automātisku faila nosaukumu pārsaukšanu
        if let aut = isAutomatic?.last {
            if aut.automatically == true {
                // tad datubāzē tiek saglabāts fails ar nosaukumu, kurš tiek apstrādāts klasē SongNameFormatter, kur tiek izmantots lietotāja izvēlētais faila nosaukuma formāts
                try! realm.write {
                    SongNameFormatter().renamingFilenames(for: self.song!)
                }
            }
        }
        
        let segueChoice = realm.objects(SegueIdentifier.self)
        // ja lietotāja virziena ceļa vērtība nav tukša
        if let seg = segueChoice.last {
            // ja lietotājs ir izvēlējies pēc faila saglabāšanas virzīties uz SongTableViewController
            if seg.identifier == "unwindToSongTVC" {
                // tad esošais skats tiek izslēgts
                self.navigationController?.popViewController(animated: true)
                delegate?.didFinishSongVC(controller: self)
            }
            // ja lietotājs ir izvēlējies pēc faila saglabāšanas virzīties uz nākamā faila rediģēšanas skatu
            if seg.identifier == "segueToNextSongVC" {

                // ja failu tabulā nākamais fails eksistē (lietotājs neatrodas uz pēdējā faila rediģēšanas skata)
                if ((selectedIndex! + 1) < tableSongs.count) {

                    // tad izveido jaunu skatu, kas manto SongViewController klasi
                    if let navController = self.navigationController {
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let nextSongVC : SongViewController = storyboard.instantiateViewController(withIdentifier: "SongViewController") as! SongViewController

                        selectedIndex = selectedIndex! + 1
                        // piešķir nākamajam skatam nākamo failu un tā indeksu
                        let selectedSong = tableSongs[selectedIndex!]
                        nextSongVC.song = selectedSong
                        nextSongVC.selectedIndex = selectedIndex
                        nextSongVC.tableSongs = tableSongs
                        // no lietotnes atvērtajiem skatiem tiek izņemts pēdējais un pievienots jaunizveidotais
                        var stack = navController.viewControllers
                        stack.remove(at: stack.count - 1)
                        stack.insert(nextSongVC, at: stack.count)
                        navController.setViewControllers(stack, animated: false)
                    }
                } else {
                    // ja lietotājs atrodas uz pēdējā faila rediģēšanas skata, tad viņu novirza atpakaļ uz SongTableViewController
                    self.navigationController?.popViewController(animated: true)
                    delegate?.didFinishSongVC(controller: self)
                }
            }
        }
    }

    // funckija tiek izsaukta, ja lietotājs veic pieskārienu navigācijas joslas pogai "cancel"
    @IBAction func cancelIsTapped(_ sender: UIBarButtonItem) {
        // noņem atvērto skatu no navigācijas
        self.navigationController?.popViewController(animated: true)
        // palaiž funkciju didFinishSongVC klasē SongTableViewController
        delegate?.didFinishSongVC(controller: self)
    }

    // funckija, kas tiek izsaukta, kad tiek mainīts skats
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ja ir pievienots albuma vāciņa attēls un ja pastāv ceļš ar nosaukumu "bigImage"
        if albumArtImage.image != UIImage(named: "defaultnophotoselected") && segue.identifier == "bigImage"{
            // tad, ja iespējams, kā ceļa mērķi uzstāda skatu AlbumArt
            if let pageDestination = segue.destination as? AlbumArt {
                // skatam AlbumArt image mainīgajam padod albuma vāciņa attēlu
                pageDestination.image = albumArtImage.image }
            else {
                print("type destination not ok") } // kpccccc
        } else {
            print("no album art selected")
            return
        }
    }
    
    //MARK: Actions

    // funckija tiek izsaukta, ja lietotājs veic pieskārienu pogai "Choose file for album art"
    @IBAction func chooseAlbumArt(_ sender: UIButton) {
        // uzstāda attēla izvēles skatu
        let imagePickerController = UIImagePickerController()
        // attēla izvēles skatam uzstāda attēla galeriju kā avotu
        imagePickerController.sourceType = .photoLibrary
        // attēle izvēles skata aizvēršanai tiek izveidots delegate, kas norāda, kad lietotājs ir veicis izvēli attēlam vai pārtraucis darbību galerijā
        imagePickerController.delegate = self
        // modāli parāda uzstādīto skatu
        present(imagePickerController, animated: true, completion: nil)
    }

    // funckija tiek izsaukta, ja lietotājs veic pieskātienu pogai "Remove"
    @IBAction func removeAlbumArt(_ sender: UIButton) {
        // piešķir attēla objektam neesoša albuma vāciņa attēlu
        albumArtImage.image = UIImage(named: "defaultnophotoselected")
        // norāda, ka lietotāja pēdējā izvēle ir bijusi albuma vāciņa dzēšana, kas tiek pārbaudīts saglabājot izmaiņas failā
        removeAlbumArtImage = true
    }
}

// opcionāla String tipa mainīgā pārkonvertēšana uz Int tipu
func optionalStringToInt(string: String?) -> Int? {
    if let string = string {
        return Int(string)
    }
    return nil
}

// funkcija, kura tiek palaista atgriežoties no SongViewController
protocol SongVCDelegate {
    func didFinishSongVC(controller: SongViewController)
}
