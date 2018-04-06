//
//  FilenameRenaming.swift
//  MetaData
//
//  Created by Melanija Grunte on 05/04/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import Foundation
import RealmSwift

class SongNameFormatter {

    func renamingFilenames(for songToBeEdited: Song) {
        let realm = try! Realm()

        var fileRenamingChoice: Results<FileRenamingChoice>?
        fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        let format = fileRenamingChoice?.last

        var style: Results<CustomFormatStringStyle>?
        style = realm.objects(CustomFormatStringStyle.self)
        let chosenStyle = style?.last

        let fileInformation: [(chosenAttribute: String, attributeValue: String, unknownAttribute: String)] = [
            ("{titleDescription}", songToBeEdited.titleDescription, "unknown title"),
            ("{albumArtistDescription}", songToBeEdited.albumArtistDescription, "unknown album artist"),
            ("{artistDescription}", songToBeEdited.artistDescription, "unknown artist"),
            ("{albumDescription}", songToBeEdited.albumDescription, "unknown album"),
            ("{trackDescription}", songToBeEdited.trackDescription, "unknown track"),
            ("{discnumberDescription}", songToBeEdited.discnumberDescription, "unknown discnumber"),
            ("{yearDescription}", songToBeEdited.yearDescription, "unknown year"),
            ("{genreDescription}", songToBeEdited.genreDescription, "unknown genre"),
            ("{composerDescription}", songToBeEdited.composerDescription, "unknown composer"),
            ("{commentDescription}", songToBeEdited.commentDescription, "unknown comment")
        ]

        var formatstyle = format?.chosenStyle

        // fileInformation.forEach { attribute  in
        // formatString = formatString.replacingOccurrences(of: attribute.chosenAttribute, with: attribute.attributeValue) }
        formatstyle = formatstyle?.replacingOccurrences(of: "{titleDescription}", with: songToBeEdited.titleDescription)
        formatstyle = formatstyle?.replacingOccurrences(of: "{albumArtistDescription}", with: songToBeEdited.albumArtistDescription)
        formatstyle = formatstyle?.replacingOccurrences(of: "{artistDescription}", with: songToBeEdited.artistDescription)
        formatstyle = formatstyle?.replacingOccurrences(of: "{albumDescription}", with: songToBeEdited.albumDescription)
        formatstyle = formatstyle?.replacingOccurrences(of: "{trackDescription}", with: songToBeEdited.trackDescription)
        formatstyle = formatstyle?.replacingOccurrences(of: "{discnumberDescription}", with: songToBeEdited.discnumberDescription)
        formatstyle = formatstyle?.replacingOccurrences(of: "{yearDescription}", with: songToBeEdited.yearDescription)
        formatstyle = formatstyle?.replacingOccurrences(of: "{genreDescription}", with: songToBeEdited.genreDescription)
        formatstyle = formatstyle?.replacingOccurrences(of: "{composerDescription}", with: songToBeEdited.composerDescription)
        formatstyle = formatstyle?.replacingOccurrences(of: "{commentDescription}", with: songToBeEdited.commentDescription)

        // custom format string stylam
        if format?.chosenTag == 8 {
            if format?.chosenStyle == "" {
                print("Custom format string has not been made!")
                // break
            }

            // ja ir izvēlēts, lai dziesmas, kurām nav kāds no izvēlētajiem atribūtiem, nemaina filename nosaukumu
            if chosenStyle?.tagReplacement == "unchanged filename" && formatstyle?.range(of: "unknown") != nil {
                print("\"\(songToBeEdited.filename)\" will not be changed")
            } else {
                songToBeEdited.filename = formatstyle!
            }
            // ja ir izvēlēts unknown %tag% vietā atstāt tukšu
            if chosenStyle?.tagReplacement == "empty" {
                fileInformation.forEach { attribute  in
                    songToBeEdited.filename = songToBeEdited.filename.replacingOccurrences(of: attribute.unknownAttribute, with: "")
                }
            }
            // ja ir izvēlēts custom tag replacement
            if chosenStyle?.tagReplacement != "empty" && chosenStyle?.tagReplacement != "unchanged filename" && chosenStyle?.tagReplacement != "unknown" && chosenStyle?.tagReplacement != "" && chosenStyle?.tagReplacement != nil {
                fileInformation.forEach { attribute  in
                    songToBeEdited.filename = songToBeEdited.filename.replacingOccurrences(of: attribute.unknownAttribute, with: (chosenStyle?.tagReplacement)!)
                }
            }
            // ja fails ir bez atribūtiem, tad " - - - - - " vietā ieliek "unknown filename"
            for attributeCount in 1...10 {
                let onlySeparations = String(repeating: " \(chosenStyle!.separationText) ", count: attributeCount)
                if songToBeEdited.filename == onlySeparations {
                    songToBeEdited.filename = "unknown filename"
                    // vienīgi teorētiski, ja tie ir filename, tad nevar būt vienādi failu nosaukumi.
                }
                // ja fails ir bez atribūtiem, bet to vietā ir kkāds replacement, tad "unknown title - unknown album - unknown track" vietā ieliek ieliek "unknown filename"
                if chosenStyle?.tagReplacement != " " || chosenStyle?.tagReplacement != "" || chosenStyle?.tagReplacement != nil {
                    var onlyReplacement = "\((chosenStyle?.tagReplacement))"
                    let repeatingString = " \(chosenStyle!.separationText) \((chosenStyle?.tagReplacement))"
                    for _ in 1..<10 {
                        if songToBeEdited.filename == onlyReplacement {
                            songToBeEdited.filename = "unknown filename"
                        }
                        onlyReplacement = onlyReplacement + repeatingString
                    } }
            }
            // ja ir izlaidies kāds atribūts un ir vairāki separationi
            var nearbySeparations = "\(chosenStyle!.separationText)  \(chosenStyle!.separationText)  \(chosenStyle!.separationText)  \(chosenStyle!.separationText)  \(chosenStyle!.separationText)  \(chosenStyle!.separationText)  \(chosenStyle!.separationText)  \(chosenStyle!.separationText)"
            for _ in 1...7 {
                songToBeEdited.filename = songToBeEdited.filename.replacingOccurrences(of: nearbySeparations, with: "\(chosenStyle!.separationText)")

                let lessSeparations = "  \(chosenStyle!.separationText)".count
                nearbySeparations = String(nearbySeparations.dropLast(lessSeparations))
            }
            // ja dziesma sākas ar separationu, jo kāds atribūts ir bijis tukšs
            if songToBeEdited.filename.hasPrefix(" \(chosenStyle!.separationText)") { // true
                let redundantPrefix = chosenStyle!.separationText.count + 1
                songToBeEdited.filename = String(songToBeEdited.filename.dropFirst(redundantPrefix))
            }
            // ja dziesma beidzas ar separationu, jo kāds atribūts ir bijis tukšs
            if songToBeEdited.filename.hasSuffix("\(chosenStyle!.separationText) ") { // true
                let redundantSuffix = chosenStyle!.separationText.count + 1
                songToBeEdited.filename = String(songToBeEdited.filename.dropLast(redundantSuffix))
            }
        } else {
            songToBeEdited.filename = formatstyle!
        }
    }
}
