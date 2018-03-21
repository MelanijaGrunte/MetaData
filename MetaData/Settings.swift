import RealmSwift
//
//  Settings.swift
//  MetaData
//
//  Created by Melanija Grunte on 31/01/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit

class Settings: UITableViewController {


    @IBOutlet weak var selectFormatStringCell: UITableViewCell!
    @IBOutlet weak var selectFormatStringButton: UIButton!
    @IBOutlet weak var configureFormatStyleCell: UITableViewCell!
    @IBOutlet weak var configureFormatStyleButton: UIButton!
    @IBOutlet weak var formatStringRenamingSwitchOutlet: UISwitch!
    @IBOutlet weak var goToNextSongWhenEditingSwitchOutlet: UISwitch!

    var switchStateForGoingToTheNextSong = false
    var switchStateForRenamingFilesAutomatically = false

    let switchKeyForGoingToTheNextSong = "goToNextSongSwitchState"
    let switchKeyForRenamingFilesAutomatically = "renameFilesAutomaticallySwitchState"


    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        goToNextSongWhenEditingSwitchOutlet.isOn = UserDefaults.standard.bool(forKey: switchKeyForGoingToTheNextSong)
        goToNextSongWhenEditingSwitch(goToNextSongWhenEditingSwitchOutlet)

        formatStringRenamingSwitchOutlet.isOn = UserDefaults.standard.bool(forKey: switchKeyForRenamingFilesAutomatically)
        formatStringRenamingSwitch(formatStringRenamingSwitchOutlet)
    }

    

    @IBAction func formatStringRenamingSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            selectFormatStringCell.backgroundColor = UIColor.white
            selectFormatStringButton.setTitleColor(.black, for: .normal)
            selectFormatStringCell.selectionStyle = UITableViewCellSelectionStyle.none
            selectFormatStringCell.isUserInteractionEnabled = true

            configureFormatStyleCell.backgroundColor = UIColor.white
            configureFormatStyleButton.setTitleColor(.black, for: .normal)
            configureFormatStyleCell.selectionStyle = UITableViewCellSelectionStyle.none
            configureFormatStyleCell.isUserInteractionEnabled = true
        }
        if (sender.isOn == false) {
//            selectFormatStringCell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.99, alpha: 1)
            selectFormatStringButton.setTitleColor(UIColor(white: 0.75, alpha:1), for: .normal)
            selectFormatStringCell.selectionStyle = UITableViewCellSelectionStyle.gray
            selectFormatStringCell.isUserInteractionEnabled = false

//            configureFormatStyleCell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.99, alpha: 1)
            configureFormatStyleButton.setTitleColor(UIColor(white: 0.75, alpha:1), for: .normal)
            configureFormatStyleCell.selectionStyle = UITableViewCellSelectionStyle.gray
            configureFormatStyleCell.isUserInteractionEnabled = false
        }
        UserDefaults.standard.set(sender.isOn, forKey: switchKeyForRenamingFilesAutomatically)
    }

    @IBAction func goToNextSongWhenEditingSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            print("hell yeah")
        }
        if (sender.isOn == false) {
            print(":(")
        }
        UserDefaults.standard.set(sender.isOn, forKey: switchKeyForGoingToTheNextSong)
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let realm = try! Realm()
            let songs = realm.objects(Song.self)

            try! realm.write {
                realm.add(songs)
            }
        }
    }

    @IBAction func unwindToSettings(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ReplaceStrings {
        }
    }

    @IBAction func loadSongs(_ sender: UIButton) {
        
        let albumArt1 = NSData(data: UIImagePNGRepresentation(UIImage(named: "chair beside a window")!)!) as Data
        let albumArt2 = NSData(data: UIImagePNGRepresentation(UIImage(named: "china")!)!) as Data
        let albumArt3 = NSData(data: UIImagePNGRepresentation(UIImage(named: "this old dog")!)!) as Data
        let albumArt4and5 = NSData(data: UIImagePNGRepresentation(UIImage(named: "drinking songs")!)!) as Data
        let albumArt6 = NSData(data: UIImagePNGRepresentation(UIImage(named: "II")!)!) as Data
        let albumArt7 = NSData(data: UIImagePNGRepresentation(UIImage(named: "LP3")!)!) as Data
        let albumArt8 = NSData(data: UIImagePNGRepresentation(UIImage(named: "sentimental goblin")!)!) as Data
        let albumArt9 = NSData(data: UIImagePNGRepresentation(UIImage(named: "howling songs")!)!) as Data
        let albumArt10 = NSData(data: UIImagePNGRepresentation(UIImage(named: "armchair boogie")!)!) as Data
        // let albumArt11 = NSData(data: UIImagePNGRepresentation(UIImage(named: "drifters / love is the devil")!)!) as Data
        let albumArt12 = NSData(data: UIImagePNGRepresentation(UIImage(named: "a stairway to the stars")!)!) as Data
        let albumArt13 = NSData(data: UIImagePNGRepresentation(UIImage(named: "rocket")!)!) as Data
        let albumArt14and15 = NSData(data: UIImagePNGRepresentation(UIImage(named: "musick to play in the dark, volume 2")!)!) as Data
        let albumArt16 = NSData(data: UIImagePNGRepresentation(UIImage(named: "東方不敗")!)!) as Data
        let albumArt17 = NSData(data: UIImagePNGRepresentation(UIImage(named: "i've always been good at true love")!)!) as Data
        let albumArt18 = NSData(data: UIImagePNGRepresentation(UIImage(named: "putni ir lohi")!)!) as Data
        // let albumArt19 = NSData(data: UIImagePNGRepresentation(UIImage(named: "the visitors")!)!) as Data
        let albumArt20 = NSData(data: UIImagePNGRepresentation(UIImage(named: "corpus I")!)!) as Data
        let albumArt21 = NSData(data: UIImagePNGRepresentation(UIImage(named: "historyjka")!)!) as Data
        let albumArt22 = NSData(data: UIImagePNGRepresentation(UIImage(named: "confusion is sex")!)!) as Data
        let albumArt23 = NSData(data: UIImagePNGRepresentation(UIImage(named: "big fish theory")!)!) as Data
        let albumArt24 = NSData(data: UIImagePNGRepresentation(UIImage(named: "bedwetter")!)!) as Data
        let albumArt25 = NSData(data: UIImagePNGRepresentation(UIImage(named: "fetish bones")!)!) as Data
        let albumArt26 = NSData(data: UIImagePNGRepresentation(UIImage(named: "g h o s t")!)!) as Data
        // let albumArt27 = NSData(data: UIImagePNGRepresentation(UIImage(named: "")!)!) as Data
        let albumArt28 = NSData(data: UIImagePNGRepresentation(UIImage(named: "behind every great man")!)!) as Data
        // let albumArt29 = NSData(data: UIImagePNGRepresentation(UIImage(named: "pēdējā derība")!)!) as Data
        let albumArt30 = NSData(data: UIImagePNGRepresentation(UIImage(named: "demiurge")!)!) as Data
        let albumArt31 = NSData(data: UIImagePNGRepresentation(UIImage(named: "hideous")!)!) as Data
        let albumArt32 = NSData(data: UIImagePNGRepresentation(UIImage(named: "lights on water")!)!) as Data
        let albumArt33 = NSData(data: UIImagePNGRepresentation(UIImage(named: "animals")!)!) as Data
        let albumArt34 = NSData(data: UIImagePNGRepresentation(UIImage(named: "who killed john todd?")!)!) as Data
        // let albumArt35 = NSData(data: UIImagePNGRepresentation(UIImage(named: "nekavējies, šīs ir spēles ar tevi")!)!) as Data
        let albumArt36 = NSData(data: UIImagePNGRepresentation(UIImage(named: "exmilitary")!)!) as Data
        let albumArt37 = NSData(data: UIImagePNGRepresentation(UIImage(named: "1990")!)!) as Data
        let albumArt38 = NSData(data: UIImagePNGRepresentation(UIImage(named: "the glow pt. 2")!)!) as Data
        let albumArt39 = NSData(data: UIImagePNGRepresentation(UIImage(named: "sviests v")!)!) as Data
        let albumArt40 = NSData(data: UIImagePNGRepresentation(UIImage(named: "yggdrasil")!)!) as Data
        let albumArt41 = NSData(data: UIImagePNGRepresentation(UIImage(named: "kill alters")!)!) as Data
        let albumArt42 = NSData(data: UIImagePNGRepresentation(UIImage(named: "no self helps")!)!) as Data
        let albumArt43 = NSData(data: UIImagePNGRepresentation(UIImage(named: "the redeemer")!)!) as Data
        let albumArt44 = NSData(data: UIImagePNGRepresentation(UIImage(named: "holding hands with jamie")!)!) as Data
        let albumArt45 = NSData(data: UIImagePNGRepresentation(UIImage(named: "karaliene anna")!)!) as Data
        let albumArt46 = NSData(data: UIImagePNGRepresentation(UIImage(named: "contact")!)!) as Data
        let albumArt47 = NSData(data: UIImagePNGRepresentation(UIImage(named: "figure 8")!)!) as Data
        let albumArt48 = NSData(data: UIImagePNGRepresentation(UIImage(named: "you take nothing")!)!) as Data
        let albumArt49 = NSData(data: UIImagePNGRepresentation(UIImage(named: "birdy nam nam live")!)!) as Data
        // let albumArt49 = NSData(data: UIImagePNGRepresentation(UIImage(named: "gloomy sunday")!)!) as Data


//        let song1 = Song()
//        song1.filename = "jandek down in a mirror"
//        song1.title = "Down in a mirror"
//        song1.artist = "Jandek"
//        song1.album = "Chair Beside a Window"
//        song1.track.value = 01
//        song1.year.value = 1982
//        song1.genre = "blues; lo-fi; folk; experimental"
//        song1.composer = "Jandek"
//        song1.comment = nil
//        song1.albumArtImage = albumArt1
//        song1.albumArtist = nil

        let realm = try! Realm()
        try! realm.write() {
            let song1 = realm.create(Song.self, value: ["jandek down in a mirror", "Down in a mirror", "Jandek", "Chair Beside a Window", 01, nil,  1982, "blues; lo-fi; folk; experimental", "Jandek", nil, albumArt1, nil])
            song1.track.value = 01
            song1.year.value = 1982
        }

        //        let song1 = Song()
        //        song1.filename = "jandek down in a mirror"
        //        song1.title = "Down in a mirror"
        //        song1.artist = "Jandek"
        //        song1.album = "Chair Beside a Window"
        //        song1.track.value = 01
        //        song1.year.value = 1982
        //        song1.genre = "blues; lo-fi; folk; experimental"
        //        song1.composer = "Jandek"
        //        song1.comment = nil
        //        song1.albumArtImage = albumArt1
        //        song1.albumArtist = nil


        let song2 = Song()
        song2.filename = "CHOMSKY CHESS CLUB - TOURING"
        song2.title = "TOURING"
        song2.artist = "CHOMSKY CHESS CLUB"
        song2.album = "CHINA"
        song2.track.value = 3
        song2.discnumber.value = nil
        song2.year.value = 2015
        song2.genre = nil
        song2.composer = nil
        song2.comment = nil
        song2.albumArtImage = albumArt2
        song2.albumArtist = nil

        let song3 = Song()
        song3.filename = "this old dog (slowed)"
        song3.title = "this old dog"
        song3.artist = "mac demarco"
        song3.album = "this old dog"
        song3.track.value = nil
        song3.discnumber.value = nil
        song3.year.value = nil
        song3.genre = nil
        song3.composer = nil
        song3.comment = "slowed"
        song3.albumArtImage = albumArt3
        song3.albumArtist = nil

        let song4 = Song()
        song4.filename = "C.F. Bundy"
        song4.title = "C.F. Bundy"
        song4.artist = "Matt Elliott"
        song4.album = "Drinking Songs"
        song4.track.value = 1
        song4.discnumber.value = nil
        song4.year.value = 2004
        song4.genre = "neofolk; electronic; dance music; slowcore"
        song4.composer = "Matt Elliott"
        song4.comment = nil
        song4.albumArtImage = albumArt4and5
        song4.albumArtist = "Vania Zouravliov"

        let song5 = Song()
        song5.filename = "the Kursk"
        song5.title = "the Kursk"
        song5.artist = "Matt Elliott"
        song5.album = "Drinking Songs"
        song5.track.value = 5
        song5.discnumber.value = nil
        song5.year.value = 2004
        song5.genre = "neofolk; electronic; dance music; slowcore"
        song5.composer = "Matt Elliott"
        song5.comment = nil
        song5.albumArtImage = albumArt4and5
        song5.albumArtist = "Vania Zouravliov"


        let song6 = Song()
        song6.filename = "METZ Acetate"
        song6.title = "Acetate"
        song6.artist = "METZ"
        song6.album = "II"
        song6.track.value = 01
        song6.discnumber.value = nil
        song6.year.value = 2015
        song6.genre = "noise rock"
        song6.composer = nil
        song6.comment = nil
        song6.albumArtImage = albumArt6
        song6.albumArtist = nil

        let song7 = Song()
        song7.filename = "Ratatat - Shiller"
        song7.title = "Shiller"
        song7.artist = "Ratatat"
        song7.album = "LP3"
        song7.track.value = nil
        song7.discnumber.value = nil
        song7.year.value = nil
        song7.genre = "experimental rock; electronic rock; neo-psychedelia; electronica"
        song7.composer = nil
        song7.comment = nil
        song7.albumArtImage = albumArt7
        song7.albumArtist = nil

        let song8 = Song()
        song8.filename = "Black Magick by Ty Segall"
        song8.title = "Black Magick"
        song8.artist = "Ty Segall"
        song8.album = nil
        song8.track.value = nil
        song8.discnumber.value = nil
        song8.year.value = nil
        song8.genre = nil
        song8.composer = nil
        song8.comment = nil
        song8.albumArtImage = albumArt8
        song8.albumArtist = nil

        let song9 = Song()
        song9.filename = "I Name This Ship the Tragedy, Bless Her and All Who Sail with Her"
        song9.title = "I Name This Ship the Tragedy, Bless Her and All Who Sail with Her"
        song9.artist = "Matt Elliott"
        song9.album = "Howling Songs"
        song9.track.value = 6
        song9.discnumber.value = nil
        song9.year.value = nil
        song9.genre = "Pop"
        song9.composer = nil
        song9.comment = nil
        song9.albumArtImage = albumArt9
        song9.albumArtist = nil

        let song10 = Song()
        song10.filename = "Michael Hurley — Troubled Waters"
        song10.title = "Troubled Waters"
        song10.artist = "Michael Hurley"
        song10.album = "Armchair Boogie"
        song10.track.value = 05
        song10.discnumber.value = nil
        song10.year.value = 1971
        song10.genre = nil
        song10.composer = "Mae West & Duke Ellington"
        song10.comment = "\"Mae West & Duke Ellington and His Orchestra\" cover"
        song10.albumArtImage = albumArt10
        song10.albumArtist = nil

        let song11 = Song()
        song11.filename = "casino lisboa"
        song11.title = nil
        song11.artist = nil
        song11.album = nil
        song11.track.value = nil
        song11.discnumber.value = nil
        song11.year.value = nil
        song11.genre = nil
        song11.composer = nil
        song11.comment = nil
        song11.albumArtImage = nil
        song11.albumArtist = nil

        let song12 = Song()
        song12.filename = "Cloudy, since you went away"
        song12.title = "Cloudy, since you went away"
        song12.artist = nil
        song12.album = nil
        song12.track.value = nil
        song12.discnumber.value = nil
        song12.year.value = nil
        song12.genre = nil
        song12.composer = nil
        song12.comment = nil
        song12.albumArtImage = albumArt12
        song12.albumArtist = nil

        let song13 = Song()
        song13.filename = "brick"
        song13.title = "Brick"
        song13.artist = "(Sandy) Alex G"
        song13.album = nil
        song13.track.value = nil
        song13.discnumber.value = nil
        song13.year.value = nil
        song13.genre = nil
        song13.composer = nil
        song13.comment = nil
        song13.albumArtImage = albumArt13
        song13.albumArtist = nil

        let song14 = Song()
        song14.filename = "ether"
        song14.title = "ether"
        song14.artist = "coil"
        song14.album = "musick to play in the dark, volume 2"
        song14.track.value = nil
        song14.discnumber.value = nil
        song14.year.value = nil
        song14.genre = "industrial; experimental; electronic; avant-garde; noise; psychedelia; avant-pop"
        song14.composer = nil
        song14.comment = nil
        song14.albumArtImage = albumArt14and15
        song14.albumArtist = nil

        let song15 = Song()
        song15.filename = "Where are you?"
        song15.title = "where are you?"
        song15.artist = "coil"
        song15.album = "musick to play in the dark, volume 2"
        song15.track.value = nil
        song15.discnumber.value = nil
        song15.year.value = nil
        song15.genre = "industrial; experimental; electronic; avant-garde; noise; psychedelia; avant-pop"
        song15.composer = nil
        song15.comment = nil
        song15.albumArtImage = albumArt14and15
        song15.albumArtist = nil

        let song16 = Song()
        song16.filename = "日出東方 唯我不敗"
        song16.title = "日出東方 唯我不敗"
        song16.artist = "Tzusing"
        song16.album = "東方不敗"
        song16.track.value = 01
        song16.discnumber.value = nil
        song16.year.value = 2017
        song16.genre = "techno; electronic; ebm; industrial; taiwan"
        song16.composer = nil
        song16.comment = nil
        song16.albumArtImage = albumArt16
        song16.albumArtist = nil

        let song17 = Song()
        song17.filename = "Articulate (Im Going So Far Into You)"
        song17.title = "Articulate (Im Going So Far Into You)"
        song17.artist = "The I.L.Y's"
        song17.album = "I've Always Been Good at True Love"
        song17.track.value = nil
        song17.discnumber.value = nil
        song17.year.value = nil
        song17.genre = nil
        song17.composer = nil
        song17.comment = "with Zach Hill and Andy Morin of Death Grips"
        song17.albumArtImage = albumArt17
        song17.albumArtist = nil

        let song18 = Song()
        song18.filename = "Mazie Smirdīgie Kociņi — Pulkstens"
        song18.title = "Pulkstens"
        song18.artist = "Mazie Smirdīgie Kociņi"
        song18.album = "Putni ir lohi"
        song18.track.value = nil
        song18.discnumber.value = nil
        song18.year.value = nil
        song18.genre = nil
        song18.composer = nil
        song18.comment = nil
        song18.albumArtImage = albumArt18
        song18.albumArtist = nil

        let song19 = Song()
        song19.filename = "Strix Nebulosa"
        song19.title = "Strix Nebulosa"
        song19.artist = "Cyclobe"
        song19.album = nil
        song19.track.value = nil
        song19.discnumber.value = nil
        song19.year.value = nil
        song19.genre = nil
        song19.composer = nil
        song19.comment = nil
        song19.albumArtImage = nil
        song19.albumArtist = nil

        let song20 = Song()
        song20.filename = "Show Me The Body - Hungry (Dreamcrusher)"
        song20.title = "Hungry"
        song20.artist = "Show Me the Body ft. Dreamcrusher"
        song20.album = "Corpus I"
        song20.track.value = nil
        song20.discnumber.value = nil
        song20.year.value = nil
        song20.genre = nil
        song20.composer = nil
        song20.comment = nil
        song20.albumArtImage = albumArt20
        song20.albumArtist = nil

        let song21 = Song()
        song21.filename = "Księżyc - Verlaine I"
        song21.title = "Verlaine I"
        song21.artist = "Księżyc"
        song21.album = "Historyjka"
        song21.track.value = nil
        song21.discnumber.value = nil
        song21.year.value = 1996
        song21.genre = "neofolk; experiental; avant-garde; polish; ambient; folk"
        song21.composer = nil
        song21.comment = nil
        song21.albumArtImage = albumArt21
        song21.albumArtist = nil

        let song22 = Song()
        song22.filename = "the world looks red"
        song22.title = "the world looks red"
        song22.artist = "sonic youth"
        song22.album = "confusion is sex"
        song22.track.value = nil
        song22.discnumber.value = nil
        song22.year.value = nil
        song22.genre = nil
        song22.composer = nil
        song22.comment = nil
        song22.albumArtImage = albumArt22
        song22.albumArtist = nil

        let song23 = Song()
        song23.filename = "Love can be..."
        song23.title = "Love can be..."
        song23.artist = "Vince Staples"
        song23.album = "Big Fish Theory"
        song23.track.value = nil
        song23.discnumber.value = nil
        song23.year.value = nil
        song23.genre = nil
        song23.composer = nil
        song23.comment = nil
        song23.albumArtImage = albumArt23
        song23.albumArtist = nil

        let song24 = Song()
        song24.filename = "haze of interference"
        song24.title = "haze of interference"
        song24.artist = nil
        song24.album = "volume 1: flick your tongue against your teeth and describe the present."
        song24.track.value = nil
        song24.discnumber.value = nil
        song24.year.value = nil
        song24.genre = nil
        song24.composer = nil
        song24.comment = nil
        song24.albumArtImage = albumArt24
        song24.albumArtist = nil

        let song25 = Song()
        song25.filename = "KBGK"
        song25.title = "KBGK"
        song25.artist = "Moor Mother"
        song25.album = "Fetish Bones"
        song25.track.value = nil
        song25.discnumber.value = nil
        song25.year.value = nil
        song25.genre = nil
        song25.composer = nil
        song25.comment = nil
        song25.albumArtImage = albumArt25
        song25.albumArtist = nil

        let song26 = Song()
        song26.filename = "tesa s"
        song26.title = "s"
        song26.artist = "tesa"
        song26.album = "G H O S T"
        song26.track.value = 4
        song26.discnumber.value = nil
        song26.year.value = 2015
        song26.genre = nil
        song26.composer = nil
        song26.comment = nil
        song26.albumArtImage = albumArt26
        song26.albumArtist = nil

        let song27 = Song()
        song27.filename = "Oytö"
        song27.title = nil
        song27.artist = "Oytö"
        song27.album = nil
        song27.track.value = nil
        song27.discnumber.value = nil
        song27.year.value = nil
        song27.genre = nil
        song27.composer = nil
        song27.comment = nil
        song27.albumArtImage = nil
        song27.albumArtist = nil

        let song28 = Song()
        song28.filename = "buttress - inferno"
        song28.title = "inferno"
        song28.artist = "the buttress"
        song28.album = "behind every great man"
        song28.track.value = nil
        song28.discnumber.value = nil
        song28.year.value = nil
        song28.genre = nil
        song28.composer = nil
        song28.comment = nil
        song28.albumArtImage = albumArt28
        song28.albumArtist = nil

        let song29 = Song()
        song29.filename = "Gatis Ziema - Maskava"
        song29.title = "Maskava"
        song29.artist = "Gatis Ziema un Karaliskā Dekadence"
        song29.album = "Pēdējā Derība"
        song29.track.value = 3
        song29.discnumber.value = nil
        song29.year.value = 2016
        song29.genre = nil
        song29.composer = nil
        song29.comment = nil
        song29.albumArtImage = nil //albumArt29
        song29.albumArtist = nil

        let song30 = Song()
        song30.filename = "emptyset: function"
        song30.title = "function"
        song30.artist = "emptyset"
        song30.album = "demiurge"
        song30.track.value = nil
        song30.discnumber.value = nil
        song30.year.value = nil
        song30.genre = nil
        song30.composer = nil
        song30.comment = nil
        song30.albumArtImage = albumArt30
        song30.albumArtist = nil

        let song31 = Song()
        song31.filename = "hideous - outting"
        song31.title = "Outting"
        song31.artist = "Jak Tripper/JakProgresso"
        song31.album = "Hideous"
        song31.track.value = 13
        song31.discnumber.value = nil
        song31.year.value = 2016
        song31.genre = nil
        song31.composer = nil
        song31.comment = nil
        song31.albumArtImage = albumArt31
        song31.albumArtist = nil

        let song32 = Song()
        song32.filename = "March Out of Step When Crossing a Bridge"
        song32.title = "March Out of Step When Crossing a Bridge"
        song32.artist = "Sum Of R"
        song32.album = "Lights on Water"
        song32.track.value = 1
        song32.discnumber.value = nil
        song32.year.value = 2013
        song32.genre = "dark ambient; ambient; drone; swiss; experimental; drone doom"
        song32.composer = nil
        song32.comment = nil
        song32.albumArtImage = albumArt32
        song32.albumArtist = nil

        let song33 = Song()
        song33.filename = "not waving - animals"
        song33.title = "28 (Bonus Track)"
        song33.artist = "Not Waving"
        song33.album = "Animals"
        song33.track.value = 12
        song33.discnumber.value = nil
        song33.year.value = 2016
        song33.genre = "electronic; superhighway; ambient; electronic"
        song33.composer = nil
        song33.comment = nil
        song33.albumArtImage = albumArt33
        song33.albumArtist = nil

        let song34 = Song()
        song34.filename = "sneeze forks"
        song34.title = "sneeze forks"
        song34.artist = "SNHK"
        song34.album = "Who Killed John Todd?"
        song34.track.value = 2
        song34.discnumber.value = nil
        song34.year.value = 2014
        song34.genre = "electronic; experimental; grindcore; hip-hop"
        song34.composer = nil
        song34.comment = nil
        song34.albumArtImage = albumArt34
        song34.albumArtist = nil

        let song35 = Song()
        song35.filename = "mona de bo - priekšpēdējais"
        song35.title = "priekšpēdējais"
        song35.artist = "mona de bo"
        song35.album = "Nekavējies, šīs ir spēles ar tevi"
        song35.track.value = 2
        song35.discnumber.value = nil
        song35.year.value = 2010
        song35.genre = "drone; psychedelic; latvian; experimental; slowcore"
        song35.composer = nil
        song35.comment = nil
        song35.albumArtImage = nil // albumArt35
        song35.albumArtist = nil

        let song36 = Song()
        song36.filename = "Death Grips - Guillotine"
        song36.title = "Guillotine"
        song36.artist = "Death Grips"
        song36.album = "Exmilitary"
        song36.track.value = 02
        song36.discnumber.value = nil
        song36.year.value = 2011
        song36.genre = "hip-hop; experimental; experimental hip-hop; industrial hip-hop; rap"
        song36.composer = nil
        song36.comment = nil
        song36.albumArtImage = albumArt36
        song36.albumArtist = nil

        let song37 = Song()
        song37.filename = "Devil Town"
        song37.title = "Devil Town"
        song37.artist = "Daniel Johnston"
        song37.album = "1990"
        song37.track.value = 01
        song37.discnumber.value = nil
        song37.year.value = 1990
        song37.genre = "indie; folk; green; singer-songwriter; lo-fi"
        song37.composer = nil
        song37.comment = nil
        song37.albumArtImage = albumArt37
        song37.albumArtist = nil

        let song38 = Song()
        song38.filename = "The Glow Pt. 2, track 1"
        song38.title = "I want wind to blow"
        song38.artist = "The Microphones"
        song38.album = "The Glow Pt. 2"
        song38.track.value = 01
        song38.discnumber.value = nil
        song38.year.value = 2001
        song38.genre = "indie; folk; green; singer-songwriter; lo-fi"
        song38.composer = nil
        song38.comment = nil
        song38.albumArtImage = albumArt38
        song38.albumArtist = nil

        let song39 = Song()
        song39.filename = "Ik Rītiņi Saule Lēca"
        song39.title = "Ik Rītiņi Saule Lēca"
        song39.artist = "Lāns"
        song39.album = "Sviests V"
        song39.track.value = 14
        song39.discnumber.value = nil
        song39.year.value = 2015
        song39.genre = "folk; latvian"
        song39.composer = nil
        song39.comment = nil
        song39.albumArtImage = albumArt39
        song39.albumArtist = nil

        let song40 = Song()
        song40.filename = "Wardruna - AnsuR"
        song40.title = "AnsuR"
        song40.artist = "Wardruna"
        song40.album = "Yggdrasil"
        song40.track.value = 05
        song40.discnumber.value = nil
        song40.year.value = 2013
        song40.genre = "folk; nordic folk; norwegian; pagan folk; neofolk"
        song40.composer = nil
        song40.comment = nil
        song40.albumArtImage = albumArt40
        song40.albumArtist = nil

        let song41 = Song()
        song41.filename = "Kill Alters - D20"
        song41.title = "D20"
        song41.artist = "Kill Alters"
        song41.album = "Kill Alters"
        song41.track.value = 07
        song41.discnumber.value = nil
        song41.year.value = 2013
        song41.genre = "folk; nordic folk; norwegian; pagan folk; neofolk"
        song41.composer = nil
        song41.comment = nil
        song41.albumArtImage = albumArt41
        song41.albumArtist = nil

        let song42 = Song()
        song42.filename = "Kill Alters - Ego Swim"
        song42.title = "Ego Swim"
        song42.artist = "Kill Alters"
        song42.album = "No Self Helps"
        song42.track.value = 04
        song42.discnumber.value = nil
        song42.year.value = 2016
        song42.genre = "alternative; electronic; rock; psychedelic"
        song42.composer = nil
        song42.comment = nil
        song42.albumArtImage = albumArt42
        song42.albumArtist = nil

        let song43 = Song()
        song43.filename = "all dogs go to heaven"
        song43.title = "all dogs go to heaven"
        song43.artist = "dean blunt"
        song43.album = "the redeemer"
        song43.track.value = 15
        song43.discnumber.value = nil
        song43.year.value = 2013
        song43.genre = "experimental electronic"
        song43.composer = nil
        song43.comment = nil
        song43.albumArtImage = albumArt43
        song43.albumArtist = nil

        let song44 = Song()
        song44.filename = "pearsforlunch.mp3"
        song44.title = "pears for lunch"
        song44.artist = "girl band"
        song44.album = "holding hands with jamie"
        song44.track.value = 2
        song44.discnumber.value = nil
        song44.year.value = 2015
        song44.genre = "post punk; noise rock; irish"
        song44.composer = nil
        song44.comment = nil
        song44.albumArtImage = albumArt44
        song44.albumArtist = nil

        let song45 = Song()
        song45.filename = "eva eva"
        song45.title = "eva eva"
        song45.artist = "ansamblis manta"
        song45.album = "karaliene anna"
        song45.track.value = 8
        song45.discnumber.value = nil
        song45.year.value = 2017
        song45.genre = "latvian"
        song45.composer = nil
        song45.comment = nil
        song45.albumArtImage = albumArt45
        song45.albumArtist = nil

        let song46 = Song()
        song46.filename = "NO NATURAL ORDER"
        song46.title = "NO NATURAL ORDER"
        song46.artist = "PHARMAKON"
        song46.album = "CONTACT"
        song46.track.value = 6
        song46.discnumber.value = nil
        song46.year.value = 2017
        song46.genre = "experimental; noise; death metal"
        song46.composer = nil
        song46.comment = nil
        song46.albumArtImage = albumArt46
        song46.albumArtist = nil

        let song47 = Song()
        song47.filename = "bye"
        song47.title = "bye"
        song47.artist = "elliott smith"
        song47.album = "figure 8"
        song47.track.value = 16
        song47.discnumber.value = nil
        song47.year.value = 2000
        song47.genre = "singer-songwriter; indie; acoustic; folk; piano; indie rock"
        song47.composer = nil
        song47.comment = nil
        song47.albumArtImage = albumArt47
        song47.albumArtist = nil

        let song48 = Song()
        song48.filename = "ragana - YOU TAKE NOTHING"
        song48.title = "YOU TAKE NOTHING"
        song48.artist = "Ragana"
        song48.album = "YOU TAKE NOTHING"
        song48.track.value = 6
        song48.discnumber.value = nil
        song48.year.value = 2017
        song48.genre = "metal; atmospheric black metal; doom; experimental; punk; screamo; sludge"
        song48.composer = nil
        song48.comment = nil
        song48.albumArtImage = albumArt48
        song48.albumArtist = nil

        let song49 = Song()
        song49.filename = "Birdy Nam Nam - Violons (Part 1)"
        song49.title = "Violons (Part 1)"
        song49.artist = "Birdy Nam Nam"
        song49.album = "Birdy Nam Nam Live"
        song49.track.value = 6
        song49.discnumber.value = nil
        song49.year.value = 2006
        song49.genre = "turntablism; electronic; funky jazz; instrumental; jazz"
        song49.composer = nil
        song49.comment = nil
        song49.albumArtImage = albumArt49
        song49.albumArtist = nil

        let song50 = Song()
        song50.filename = "Gloomy Sunday (original version)"
        song50.title = "Gloomy Sunday"
        song50.artist = nil
        song50.album = nil
        song50.track.value = nil
        song50.discnumber.value = nil
        song50.year.value = 1933
        song50.genre = nil
        song50.composer = "Rezső Seress"
        song50.comment = "poem by László Jávor"
        song50.albumArtImage = nil
        song50.albumArtist = nil

        try! realm.write{
            realm.add([song2, song3, song4, song5, song6, song7, song8, song9, song10, song11, song12, song13, song14, song15, song16, song17, song18, song19, song20, song21, song22, song23, song24, song25, song26, song27, song28, song29, song30, song31, song32, song33, song34, song35, song36, song37, song38, song39, song40, song41, song42, song43, song44, song45, song46, song47, song48, song49, song50])
        }

    }
}
