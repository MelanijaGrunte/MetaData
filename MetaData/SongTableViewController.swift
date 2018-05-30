//
//  SongTableViewController.swift
//  MetaData
//
//  Created by Melanija Grunte on 12/11/2017.
//  Copyright © 2017 Melanija Grunte. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class SongTableViewController: UITableViewController, UISearchBarDelegate, SongVCDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var songs = [Song]()
    var displayedSongs: Results<Song>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ielādē failus
        loadSampleSongs()

        // uztver veiktās izmaiņas meklēšānas lauciņā un kā beigšanas simbolu uzstāda .done
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done

        self.tableView.reloadData()
    }
    
    // MARK: Table view data source

    // izveido tabulai vienu sekciju
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // izveido tabulai tik šūnas, cik ir ielādēto failu
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedSongs.count
    }

    // uzstāda tabulas šūnu saturu
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // izveido šūnas mainīgo piešķirot tai izklājlapas šūnu ar identifikatoru "SongTableViewCell" un piešķirot tai klasi SongTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as? SongTableViewCell else {
            fatalError("The dequeued cell is not an instance of SongTableViewCell.")
        }
        // lai līnijas starp rindām būtu no malas līdz malai
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let song = displayedSongs[indexPath.row]
        let realm = try! Realm()
        let columnAttribute = realm.objects(Column.self)
        // ja lietotājs ir veicis kolonnas uzraksta vērtības izvēli
        if let column = columnAttribute.last {
            // šūnām uzstāda uzrakstu ar izvēlētā atribūta tekstu
            cell.columnAttribute.textColor = UIColor.black
            cell.columnAttribute.text = song[column.choice] as? String
            // skaitliskos atribūtus pārveido String tipa mainīgajos
            if column.choice == "track" || column.choice == "discnumber" || column.choice == "year" {
                if let numberAttribute = song[column.choice] {
                    cell.columnAttribute.text = String(describing: numberAttribute)
                }
            }
            // ja izvēlētais atribūts konkrētajai šūnai ir tukšs
            if cell.columnAttribute.text == nil {
                // šūnai uzstāda uzrakstu ar faila nosaukumu
                cell.columnAttribute.text = song.filename
                // lai lietotājs spētu atšķirt, ka konkrētajai šūnai netiek attēlots uzraksts ar izvēlēto atribūtu, faila nosaukuma tekstu uzrāda pelēkā krāsā
                cell.columnAttribute.textColor = UIColor(white: 0.75, alpha:1)
            }
        } else {
            // citādāk šūnām uzrāda faila nosaukumus
            cell.columnAttribute.text = song.filename
        }
        // ja failam eksistē albuma vāciņš, tad tas tiek uzrādīts attēla objektā
        if song.albumArtImage != nil {
            cell.albumArtImage?.image = UIImage(data: song.albumArtImage!)
        // ja albuma vāciņa nav, attēla objektā uzrāda neesoša albuma vāciņa attēlu
        } else {
            cell.albumArtImage.image = UIImage(named: "defaultnoalbumart")
        }
        return cell
    }

    // gadījumā, ja lietotājs bija veicis izmaiņas vairākos failus, tabulas skatu atkārtoti ielādē uzrādod rindu vērtībās izmaiņas
    override func viewWillAppear(_ animated: Bool) {
        let segueChoice = realm.objects(SegueIdentifier.self)
        let seg = segueChoice.last
        if seg?.identifier == "segueToNextSongVC" {
            super.viewWillAppear(animated)
            self.tableView.reloadData()
        }
    }

    // MARK: Searchbar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // ja meklēšanas lodziņā ir ievadīts teksts
        if let searchQuery = searchBar.text, !searchQuery.isEmpty {
            let realm = try! Realm()
            // izveido nosacījumu, kur atribūtu sastāvā ir meklētais teksts
            let template = NSPredicate(format: "filename CONTAINS[c] $SRCH OR title CONTAINS[c] $SRCH OR album CONTAINS[c] $SRCH OR artist CONTAINS[c] $SRCH OR composer CONTAINS[c] $SRCH OR comment CONTAINS[c] $SRCH")
            let subVars = ["SRCH": searchQuery]
            let predicate = template.withSubstitutionVariables(subVars)
            // izvada visus failus, kuriem nosacījumi izpildās
            let songs = realm.objects(Song.self).filter(predicate)
            let attribute = realm.objects(Attribute.self)
            // ja Attribute klases attribute mainīgais nav tukšs, tabula tiek kārtota tā alfabētiskajā secībā. Faili, kuriem šī atribūta vērtība ir tukša, tiek kārtota pēc to nosaukuma
            if let attr = attribute.last {
                displayedSongs = songs.sorted(by: [SortDescriptor(keyPath: attr.choice, ascending: true), "filename"])
            } else {
                displayedSongs = songs.sorted(byKeyPath: "filename")
            }
        }
        // ja meklēšanas lodziņš ir tukšs, audio failus ielādē kā parasti
        if searchText == "" {
            loadSampleSongs()
        }
        self.tableView.reloadData()
    }

    // lietotājam veicot pieskārienu uz meklēšanas pogas, skats tiek uzstādīts līdz tā augšmalai, kur ir redzams meklēšanas ievades lauciņš
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        tableView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
    }

    // MARK: - Navigation

    // sagatavo nākamajam skatam
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // sagatavo skatam, kas parāda faila metadatus
        switch segue.identifier {
        case "ShowDetail":
            // piešķir SongViewController kā mērķi
            guard let songDetailViewController = segue.destination as? SongViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            // piešķir šūnu, kurai tika veikts pieskāriens, kā nākamā skata izsaucēju
            guard let selectedSongCell = sender as? SongTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            // izveido mainīgo piešķirot tam izvēlētās šūnas indeksu
            guard let indexPath = tableView.indexPath(for: selectedSongCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            // aizsūta ielādēto failu mainīgo, izvēlētā faila indeksu mainīgo un paša izvēlētā faila mainīgo uz nākamo skatu SongViewController
            songDetailViewController.tableSongs = displayedSongs
            songDetailViewController.selectedIndex = indexPath.row
            songDetailViewController.song = displayedSongs[indexPath.row]
            // saņem vērtības no SongViewController
            songDetailViewController.delegate = self
        default: ()
        }
    }
    
    //MARK: Actions

    // izejot no SongViewController skata
    func didFinishSongVC(controller: SongViewController) {
        // ja virziens nāk no SongViewController, kur eksistēja mainīgais song
        if let sourceViewController = controller as? SongViewController, let song = sourceViewController.song {
            // ja saglabājies indeks izvēlētajai tabulas šūnai
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                loadSampleSongs()
                // ielādē tabulu lietotāja stāvoklī šūnas izvēles veikšanas laikā
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
    }
    
    ///MARK: Private Methods

    // failu ielādēšana
    private func loadSampleSongs() {
        let realm = try! Realm()
        let songs = realm.objects(Song.self)
        let attribute = realm.objects(Attribute.self)
        if let attr = attribute.last {
            // displayedSongs mainīgajam piešķir failus, kuri ir kārtoti pirmkārt pēc lietotāja izvēlētā atribūta alfabētiskā secībā, otrkārt (ja atribūta vērtība ir nil) pēc faila nosaukuma
            displayedSongs = songs.sorted(by: [SortDescriptor(keyPath: attr.choice, ascending: true), "filename"])
        } else {
            // ja izvēlētā atribūta vērtība ir tukša, displayedSongs mainīgajam piešķir failus, kuri ir kārtoti pēc faila nosaukuma alfabētiskā secībā
            displayedSongs = songs.sorted(byKeyPath: "filename")
        }
        self.tableView.reloadData()
    }
}
