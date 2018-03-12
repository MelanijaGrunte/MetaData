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
    @objc dynamic var filename: String = ""
    @objc dynamic var title: String?
    @objc dynamic var artist: String?
    @objc dynamic var album: String?
    var track = RealmOptional<Int>()       // !!!
    var discnumber = RealmOptional<Int>()       // !!!
    var year = RealmOptional<Int>()       // !!!
    @objc dynamic var genre: String?
    @objc dynamic var composer: String?
    @objc dynamic var comment: String?
    @objc dynamic var albumArtImage: Data?
    @objc dynamic var albumArtist: String?
    let songs = List<Song>()
    
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
    var trackDescription: String {
        if let track = track.value {
            return String(describing: track)
        } else {
            return "unknown track" }          // !!!
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


//public class SongOld {
//
//    //MARK: Properties
//
//    public var filename: String
//    public var title: String?
//    public var artist: String?
//    public var album: String?
//    public var track: Int?
//    public var year: Int?
//    public var genre: String?
//    public var composer: String?
//    public var comment: String?
//    public var albumArtImage: UIImage?
//    public var albumArtist: String?
//
//    //MARK: Initialization
//    
//    init?(
//        filename: String,
//        title: String? = nil,
//        artist: String? = nil,
//        album: String? = nil,
//        track: Int? = nil,
//        year: Int? = nil,
//        genre: String? = nil,
//        composer: String? = nil,
//        comment: String? = nil,
//        albumArtImage: UIImage? = nil,
//        albumArtist: String? = nil
//    ) {
//
//        guard !filename.isEmpty else {
//            return nil
//        }
//        
//        self.filename = filename
//        self.title = title
//        self.artist = artist
//        self.album = album
//        self.track = track
//        self.year = year
//        self.genre = genre
//        self.composer = composer
//        self.comment = comment
//        self.albumArtImage = albumArtImage
//        self.albumArtist = albumArtist
//    }
//
//}
//
////extension Song: Equatable {
////    static public func ==(lhs: Song, rhs: Song) -> Bool {
////        return lhs.filename == rhs.filename
////    }
////}
//
