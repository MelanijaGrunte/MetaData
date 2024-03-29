//
//  Song.swift
//  MetaData
//
//  Created by Melanija Grunte on 11/11/2017.
//  Copyright © 2017 Melanija Grunte. All rights reserved.
//

import UIKit
import RealmSwift

class Song: Object {
    // piešķir faila objektam metadatus
    @objc dynamic var filename: String = ""
    @objc dynamic var title: String?
    @objc dynamic var artist: String?
    @objc dynamic var album: String?
    // Realmā Int? nevar būt jo swiftā Int nevar tikt deklarēts kā @objc
    var track = RealmOptional<Int>()
    var discnumber = RealmOptional<Int>()
    var year = RealmOptional<Int>()
    @objc dynamic var genre: String?
    @objc dynamic var composer: String?
    @objc dynamic var comment: String?
    // albuma vāciņa attēla mainīgais ir Data tipa mainīgais, jo Realm neatbalsta UIImage tipu
    @objc dynamic var albumArtImage: Data?
    @objc dynamic var albumArtist: String?

    // izveido sarakstu no Song objektiem
    let songs = List<Song>()

    // piešķir metadatu aprakstiem to vērtības, ja tādas eksistē, ja neeksistē, piešķir tekstu par to neesamību, ko var pielietot formatējot failu nosaukumus
    var titleDescription: String {
        if title == "" {
            return "unknown title" }
        else {
            return title ?? "unknown title" }
    }
    var artistDescription: String {
        if artist == "" {
            return "unknown artist" }
        else {
            return artist ?? "unknown artist" }
    }
    var albumDescription: String {
        if album == "" {
            return "unknown album" }
        else {
            return album ?? "unknown album" }
    }
    // pārveido skaitliskos mainīgos String tipa mainīgajos
    var trackDescription: String {
        if let track = track.value {
            return String(describing: track)
        } else {
            return "unknown track" }
    }
    var discnumberDescription: String {
        if let discnumber = discnumber.value {
            return String(describing: discnumber)
        } else {
            return "unknown discnumber" }
    }
    var yearDescription: String {
        if let year = year.value {
            return String(describing: year)
        } else {
            return "unknown year" }
    }
    var genreDescription: String {
        if genre == "" {
            return "unknown genre" }
        else {
            return genre ?? "unknown genre" }
    }
    var composerDescription: String {
        if composer == "" {
            return "unknown composer" }
        else {
            return composer ?? "unknown composer" }
    }
    var commentDescription: String {
        if comment == "" {
            return "unknown comment" }
        else {
            return comment ?? "unknown comment" }
    }
    var albumArtistDescription: String {
        if albumArtist == "" {
            return "unknown album artist" }
        else {
            return albumArtist ?? "unknown album artist" }
    }
}
