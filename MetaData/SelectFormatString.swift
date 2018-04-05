//
//  SelectFormatString.swift
//  MetaData
//
//  Created by Melanija Grunte on 01/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class SelectFormatString: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var selectFormatStringView: UIView!
    @IBOutlet weak var selectFormatStringTableView: UITableView!
    
    enum filenameType: String {
        case artistAlbumTrackTitle = "artist - album - track - title"
        case artistAlbumTitle = "artist - album - title"
        case artistTitle = "artist - title"
        case albumTrackTitle = "album - track - title"
        case albumTitle = "album - title"
        case trackTitle = "track - title"
        case title = "title"
        case artistTrackAlbum = "artist - track - album"
        case defaultString = "your default format style"
    }
    
    func filenameString(for type: filenameType) -> String {
        switch type {
        case .artistAlbumTrackTitle:
            return "{artistDescription} - {albumDescription} - {trackDescription} - {titleDescription}"
        case .artistAlbumTitle:
            return "{artistDescription} - {albumDescription} - {titleDescription}"
        case .artistTitle:
            return "{artistDescription} - {titleDescription}"
        case .albumTrackTitle:
            return "{albumDescription} - {trackDescription} - {titleDescription}"
        case .albumTitle:
            return "{albumDescription} - {titleDescription}"
        case .trackTitle:
            return "{trackDescription} - {titleDescription}"
        case .title:
            return "{titleDescription}"
        case .artistTrackAlbum:
            return "{artistDescription} - {trackDescription} - {albumDescription}"
        case .defaultString:
            let realm = try! Realm()
            var customFormatString: Results<CustomFormatStringStyle>?
            customFormatString = realm.objects(CustomFormatStringStyle.self)
            let style = customFormatString?.last
            return style!.stringStyle
        }
    }
    
    let types: [filenameType] = [
        .artistAlbumTrackTitle,
        .artistAlbumTitle,
        .artistTitle,
        .albumTrackTitle,
        .albumTitle,
        .trackTitle,
        .title,
        .artistTrackAlbum,
        .defaultString
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.popViewController(animated: true)
        selectFormatStringTableView.dataSource = self
        selectFormatStringTableView.delegate = self
        selectFormatStringTableView.layer.cornerRadius = 10
        selectFormatStringTableView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count;
    }
    
    // MARK: actions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = types[indexPath.row]
        let realm = try! Realm()
        
        var whenNoTag: Results<TagReplacement>?
        whenNoTag = realm.objects(TagReplacement.self)
        let replacement = whenNoTag?.last
        
        var whatSeparates: Results<Separation>?
        whatSeparates = realm.objects(Separation.self)
        let separation = whatSeparates?.last
        
        try! realm.write {
            for songs in realm.objects(Song.self) {
                
                let fileInformation: [(chosenAttribute: String, attributeValue: String, unknownAttribute: String)] = [
                    ("{titleDescription}", songs.titleDescription, "unknown title"),
                    ("{albumArtistDescription}", songs.albumArtistDescription, "unknown album artist"),
                    ("{artistDescription}", songs.artistDescription, "unknown artist"),
                    ("{albumDescription}", songs.albumDescription, "unknown album"),
                    ("{trackDescription}", songs.trackDescription, "unknown track"),
                    ("{discnumberDescription}", songs.discnumberDescription, "unknown discnumber"),
                    ("{yearDescription}", songs.yearDescription, "unknown year"),
                    ("{genreDescription}", songs.genreDescription, "unknown genre"),
                    ("{composerDescription}", songs.composerDescription, "unknown composer"),
                    ("{commentDescription}", songs.commentDescription, "unknown comment")
                ]
                
                var formatString = filenameString(for: type)
                //                fileInformation.forEach { attribute  in
                //                formatString = formatString.replacingOccurrences(of: attribute.chosenAttribute, with: attribute.attributeValue) }
                formatString = formatString.replacingOccurrences(of: "{titleDescription}", with: songs.titleDescription)
                formatString = formatString.replacingOccurrences(of: "{albumArtistDescription}", with: songs.albumArtistDescription)
                formatString = formatString.replacingOccurrences(of: "{artistDescription}", with: songs.artistDescription)
                formatString = formatString.replacingOccurrences(of: "{albumDescription}", with: songs.albumDescription)
                formatString = formatString.replacingOccurrences(of: "{trackDescription}", with: songs.trackDescription)
                formatString = formatString.replacingOccurrences(of: "{discnumberDescription}", with: songs.discnumberDescription)
                formatString = formatString.replacingOccurrences(of: "{yearDescription}", with: songs.yearDescription)
                formatString = formatString.replacingOccurrences(of: "{genreDescription}", with: songs.genreDescription)
                formatString = formatString.replacingOccurrences(of: "{composerDescription}", with: songs.composerDescription)
                formatString = formatString.replacingOccurrences(of: "{commentDescription}", with: songs.commentDescription)
                
                // custom format string stylam
                if type == types[8] {
                    if formatString == "" {
                        print("Custom format string has not been made!")
                        break
                    }
                    
                    // ja ir izvēlēts, lai dziesmas, kurām nav kāds no izvēlētajiem atribūtiem, nemaina filename nosaukumu
                    if replacement?.tagReplacement == "unchanged filename" && formatString.range(of: "unknown") != nil {
                        print("\"\(songs.filename)\" will not be changed")
                    } else {
                        songs.filename = formatString
                    }
                    // ja ir izvēlēts unknown %tag% vietā atstāt tukšu
                    if replacement?.tagReplacement == "empty" {
                        fileInformation.forEach { attribute  in
                            songs.filename = songs.filename.replacingOccurrences(of: attribute.unknownAttribute, with: "")
                        }
                    }
                    // ja ir izvēlēts custom tag replacement
                    if replacement?.tagReplacement != "empty" && replacement?.tagReplacement != "unchanged filename" && replacement?.tagReplacement != "unknown" && replacement?.tagReplacement != "" && replacement?.tagReplacement != nil {
                        fileInformation.forEach { attribute  in
                            songs.filename = songs.filename.replacingOccurrences(of: attribute.unknownAttribute, with: (replacement?.tagReplacement)!)
                        }
                    }
                    // ja fails ir bez atribūtiem, tad " - - - - - " vietā ieliek "unknown filename"
                    for attributeCount in 1...10 {
                        let onlySeparations = String(repeating: " \(separation!.separationText) ", count: attributeCount)
                        if songs.filename == onlySeparations {
                            songs.filename = "unknown filename"
                            // vienīgi teorētiski, ja tie ir filename, tad nevar būt vienādi failu nosaukumi.
                        }
                        // ja fails ir bez atribūtiem, bet to vietā ir kkāds replacement, tad "unknown title - unknown album - unknown track" vietā ieliek ieliek "unknown filename"
                        if replacement?.tagReplacement != " " || replacement?.tagReplacement != "" || replacement?.tagReplacement != nil {
                            var onlyReplacement = "\((replacement?.tagReplacement))"
                            let repeatingString = " \(separation!.separationText) \((replacement?.tagReplacement))"
                            for _ in 1..<10 {
                                if songs.filename == onlyReplacement {
                                    songs.filename = "unknown filename"
                                }
                                onlyReplacement = onlyReplacement + repeatingString
                            } }
                    }
                    // ja ir izlaidies kāds atribūts un ir vairāki separationi
                    var nearbySeparations = "\(separation!.separationText)  \(separation!.separationText)  \(separation!.separationText)  \(separation!.separationText)  \(separation!.separationText)  \(separation!.separationText)  \(separation!.separationText)  \(separation!.separationText)"
                    for _ in 1...7 {
                        songs.filename = songs.filename.replacingOccurrences(of: nearbySeparations, with: "\(separation!.separationText)")
                        
                        let lessSeparations = "  \(separation!.separationText)".count
                        nearbySeparations = String(nearbySeparations.dropLast(lessSeparations))
                    }
                    // ja dziesma sākas ar separationu, jo kāds atribūts ir bijis tukšs
                    if songs.filename.hasPrefix(" \(separation!.separationText)") { // true
                        let redundantPrefix = separation!.separationText.count + 1
                        songs.filename = String(songs.filename.dropFirst(redundantPrefix))
                    }
                    // ja dziesma beidzas ar separationu, jo kāds atribūts ir bijis tukšs
                    if songs.filename.hasSuffix("\(separation!.separationText) ") { // true
                        let redundantSuffix = separation!.separationText.count + 1
                        songs.filename = String(songs.filename.dropLast(redundantSuffix))
                    }
                } else {
                    songs.filename = formatString
                }
            }
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = types[indexPath.row].rawValue
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        
        let realm = try! Realm()
        var customFormatString: Results<CustomFormatStringStyle>?
        customFormatString = realm.objects(CustomFormatStringStyle.self)
        let style = customFormatString?.last
        if style!.stringStyle == "" && indexPath.row == 8 {
            let customStringStyleCell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellWithACustomStyle")
            customStringStyleCell.textLabel?.textColor = UIColor(white: 0.75, alpha:1)
            customStringStyleCell.textLabel?.text = types[indexPath.row].rawValue
            customStringStyleCell.textLabel?.font = cell.textLabel?.font.withSize(20)
            customStringStyleCell.selectionStyle = UITableViewCellSelectionStyle.gray
            customStringStyleCell.isUserInteractionEnabled = false
            return customStringStyleCell
        }
        return cell
    }
}

