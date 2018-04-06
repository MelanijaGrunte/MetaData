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

        print("1")

        let fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        var chosenFormatStyle = fileRenamingChoice.last

        let style = realm.objects(CustomFormatStringStyle.self)
        let chosenStyle = style.last

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

        print("3")


        var formatStyle = chosenFormatStyle?.chosenStyle

        // fileInformation.forEach { attribute  in
        // formatString = formatString.replacingOccurrences(of: attribute.chosenAttribute, with: attribute.attributeValue) }
        formatStyle = formatStyle?.replacingOccurrences(of: "{filename}", with: songToBeEdited.filename)
        formatStyle = formatStyle?.replacingOccurrences(of: "{titleDescription}", with: songToBeEdited.titleDescription)
        formatStyle = formatStyle?.replacingOccurrences(of: "{albumArtistDescription}", with: songToBeEdited.albumArtistDescription)
        formatStyle = formatStyle?.replacingOccurrences(of: "{artistDescription}", with: songToBeEdited.artistDescription)
        formatStyle = formatStyle?.replacingOccurrences(of: "{albumDescription}", with: songToBeEdited.albumDescription)
        formatStyle = formatStyle?.replacingOccurrences(of: "{trackDescription}", with: songToBeEdited.trackDescription)
        formatStyle = formatStyle?.replacingOccurrences(of: "{discnumberDescription}", with: songToBeEdited.discnumberDescription)
        formatStyle = formatStyle?.replacingOccurrences(of: "{yearDescription}", with: songToBeEdited.yearDescription)
        formatStyle = formatStyle?.replacingOccurrences(of: "{genreDescription}", with: songToBeEdited.genreDescription)
        formatStyle = formatStyle?.replacingOccurrences(of: "{composerDescription}", with: songToBeEdited.composerDescription)
        formatStyle = formatStyle?.replacingOccurrences(of: "{commentDescription}", with: songToBeEdited.commentDescription)

        // custom format string stylam
        if chosenFormatStyle?.chosenTag == 8 {
            print("4")

            if chosenFormatStyle?.chosenStyle == "" {
                print("Custom format string has not been made!")
                // break
            }

            // ja ir izvēlēts, lai dziesmas, kurām nav kāds no izvēlētajiem atribūtiem, nemaina filename nosaukumu
            if chosenStyle?.tagReplacement == "unchanged filename" && formatStyle?.range(of: "unknown") != nil {
                print("\"\(songToBeEdited.filename)\" will not be changed")
            } else {
                songToBeEdited.filename = formatStyle!
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
            songToBeEdited.filename = formatStyle!
        }
    }
}
